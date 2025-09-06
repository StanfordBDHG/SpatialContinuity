//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import Combine
import CoreMedia
import Foundation
import MultipeerConnectivity
import Transcoding

// MARK: - Networking

@Observable public final class Networking: NSObject {
    // MARK: Lifecycle

    public override init() {
        super.init()

        videoEncoderTask = Task {
            for await data in videoEncoderAnnexBAdaptor.annexBData {
                try? await realtimeStreaming.send(data: data, messageType: .hevcData)
            }
        }

        videoDecoderTask = Task {
            for await decodedSampleBuffer in videoDecoder.decodedSampleBuffers {
                if let pixelBuffer = decodedSampleBuffer.imageBuffer {
                    for continuation in pixelBufferContinuations.values {
                        continuation.yield(pixelBuffer)
                    }
                }
            }
        }

        receivedMessageTask = Task {
            for await (data, _) in realtimeStreaming.receivedMessages {
                videoDecoderAnnexBAdaptor.decode(data)
            }
        }
    }

    public var isConnected: Bool { realtimeStreaming.isConnected }

    @ObservationIgnored public var pixelBuffers: AsyncStream<CVPixelBuffer> {
        .init { continuation in
            let id = UUID()
            pixelBufferContinuations[id] = continuation
            continuation.onTermination = { [weak self] _ in
                self?.pixelBufferContinuations[id] = nil
            }
        }
    }

    public func attemptToReconnect() {
        realtimeStreaming.attemptToReconnect()
    }

    public func disconnect() {
        realtimeStreaming.disconnect()
    }

    public func setBitrate(_ bitrate: Int) {
        videoEncoder.config.averageBitRate = bitrate
    }

    public func setExpectedFrameRate(_ frameRate: Int) {
        videoEncoder.config.expectedFrameRate = frameRate
    }

    public func send(_ pixelBuffer: CVPixelBuffer) {
        guard isConnected else { return }
        videoEncoder.encode(pixelBuffer)
    }

    public func startBrowsing() {
        realtimeStreaming.startBrowsing(for: Constants.bonjourServiceTypeTCP)
    }

    public func startAdvertising() {
        realtimeStreaming.startListening(for: Constants.bonjourServiceTypeTCP)
    }

    public func stopAdvertising() {
        realtimeStreaming.stopListening()
    }

    public func resetEncoder() {
        videoEncoder.invalidate()
    }

    // MARK: Private

    private let realtimeStreaming = RealtimeStreaming()

    private var videoEncoderTask: Task<Void, Never>?
    private var videoDecoderTask: Task<Void, Never>?
    private var receivedMessageTask: Task<Void, Never>?

    @ObservationIgnored private lazy var videoEncoder = VideoEncoder(config: .ultraLowLatency)
    @ObservationIgnored private lazy var videoEncoderAnnexBAdaptor = VideoEncoderAnnexBAdaptor(
        videoEncoder: videoEncoder
    )
    @ObservationIgnored private lazy var videoDecoder = VideoDecoder(config: .init())
    @ObservationIgnored private lazy var videoDecoderAnnexBAdaptor = VideoDecoderAnnexBAdaptor(
        videoDecoder: videoDecoder,
        codec: .hevc
    )

    @ObservationIgnored private var pixelBufferContinuations: [UUID: AsyncStream<CVPixelBuffer>.Continuation] = [:]
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
}
