//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import AVFoundation
import CoreImage
import SwiftUI
import UIKit

// References:
// * https://developer.apple.com/tutorials/sample-apps/capturingphotos-camerapreview
// * https://developer.apple.com/documentation/avfoundation/capture_setup/avcambarcode_detecting_barcodes_and_faces
// * https://www.neuralception.com/detection-app-tutorial-camera-feed/

class SCC: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case unconfigured
    }

    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var setupResult: SessionSetupResult = .unconfigured
    private var addToPreviewStream: ((CIImage) -> Void)?
    private var addToPhotoStream: ((AVCapturePhoto) -> Void)?
    private var addToVideoStream: ((CVPixelBuffer) -> Void)?
    private var photoOutput: AVCapturePhotoOutput?

    private var deviceOrientation: UIDeviceOrientation {
        var orientation = UIDevice.current.orientation
        if orientation == UIDeviceOrientation.unknown {
            orientation = UIDeviceOrientation.portrait
        }
        return orientation
    }

    // Verbatim from https://developer.apple.com/tutorials/sample-apps/capturingphotos-camerapreview
    lazy var previewStream: AsyncStream<CIImage> = AsyncStream { continuation in
        addToPreviewStream = { ciImage in
            continuation.yield(ciImage)
        }
    }

    lazy var photoStream: AsyncStream<AVCapturePhoto> = AsyncStream { continuation in
        addToPhotoStream = { photo in
            continuation.yield(photo)
        }
    }

    lazy var videoStream: AsyncStream<CVPixelBuffer> = AsyncStream { continuation in
        addToVideoStream = { buffer in
            continuation.yield(buffer)
        }
    }

    var minZoom: CGFloat = 1.0
    var maxZoom: CGFloat = 1.0
    var videoDevice: AVCaptureDevice?

    override init() {
        super.init()
        setupCamera()
    }

    private func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation? {
        switch deviceOrientation {
        case .portrait: AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown: AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft: AVCaptureVideoOrientation.landscapeRight
        case .landscapeRight: AVCaptureVideoOrientation.landscapeLeft
        default: nil
        }
    }

    private func checkCameraAuthorization() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
        default:
            setupResult = .unconfigured
            print("No camera access")
            return false
        }

        return true
    }

    func setupCamera() {
        if !checkCameraAuthorization() {
            return
        }

        captureSession.beginConfiguration()

        self.videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

        guard let videoDevice else {
            print("Couldn't select capture device")
            setupResult = .unconfigured
            return
        }

        minZoom = videoDevice.minAvailableVideoZoomFactor
        maxZoom = min(videoDevice.maxAvailableVideoZoomFactor, 16)

        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            } else {
                print("Could not add video device input to the session")
                setupResult = .unconfigured
                return
            }

            // Verbatim from https://developer.apple.com/tutorials/sample-apps/capturingphotos-camerapreview
            let videoDeviceOutput = AVCaptureVideoDataOutput()
            videoDeviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
            if captureSession.canAddOutput(videoDeviceOutput) {
                captureSession.addOutput(videoDeviceOutput)
            } else {
                print("Could not add video device output to the session")
                setupResult = .unconfigured
                return
            }

            let photoDeviceOutput = AVCapturePhotoOutput()

            captureSession.sessionPreset = AVCaptureSession.Preset.photo

            if captureSession.canAddOutput(photoDeviceOutput) {
                captureSession.addOutput(photoDeviceOutput)
                photoOutput = photoDeviceOutput
                // self.photoOutput!.isHighResolutionCaptureEnabled = true
                photoOutput?.maxPhotoQualityPrioritization = .quality
            } else {
                print("Could not add photo device output to the session")
                setupResult = .unconfigured
                return
            }
        } catch {
            print("Couldn't obtain device input")
            setupResult = .unconfigured
            return
        }

        captureSession.commitConfiguration()
        setupResult = .success
    }

    func start() async {
        if setupResult == .unconfigured {
            return
        }

        sessionQueue.async { [self] in
            captureSession.startRunning()
        }
    }

    // Verbatim from https://developer.apple.com/tutorials/sample-apps/capturingphotos-camerapreview
    func captureOutput(
        _: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else {
            return
        }

        if connection.isVideoOrientationSupported,
           let videoOrientation = videoOrientationFor(deviceOrientation) {
            connection.videoOrientation = videoOrientation
        }

        addToVideoStream?(pixelBuffer)
        addToPreviewStream?(CIImage(cvPixelBuffer: pixelBuffer))
    }
}

extension SCC: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            print("Couldn't capture frame: \(error.localizedDescription)")
            return
        }
        addToPhotoStream?(photo)
    }
}
