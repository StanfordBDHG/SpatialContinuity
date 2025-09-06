//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import AVFoundation
import SwiftUI

class SCCModel: ObservableObject {
    var scc: SCC = .init()
    let peerConn: SCCPeerConnection = .init()
    let networking: Networking = .init()

    @Published var viewFinderImage: UIImage?

    init() {
        Task {
            await handleSCCPreviewStream()
        }

        Task {
            await handleSCCPhotoStream()
        }
        
        Task {
            await handleSCCVideoStream()
        }
        
        networking.startAdvertising()
    }

    // Verbatim
    func handleSCCPreviewStream() async {
        let imageStream = scc.previewStream
            .map(\.uiImage)

        for await image in imageStream {
            Task { @MainActor in
                viewFinderImage = image
            }
        }
    }

    func handleSCCPhotoStream() async {
        for await photoFromStream in scc.photoStream {
            // peerConn.sendImage(data: photoFromStream.fileDataRepresentation())
        }
    }
    
    func handleSCCVideoStream() async {
        for await buffer in scc.videoStream {
            networking.send(buffer)
        }
    }
}

// Verbatim from https://developer.apple.com/tutorials/sample-apps/capturingphotos-camerapreview
extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: extent) else {
            return nil
        }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }

    var uiImage: UIImage? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
