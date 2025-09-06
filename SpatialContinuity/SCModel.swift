//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

public class SCModel: ObservableObject {
    public let networking: Networking = .init()
    @Published public var currentFrame: UIImage?
    @Published public var currentPin: UIImage?

    init() {
        networking.startBrowsing()

        Task {
            await handleIncomingVideo()
        }
    }

    func handleIncomingVideo() async {
        for await buffer in networking.pixelBuffers {
            Task { @MainActor in
                currentFrame = CIImage(cvPixelBuffer: buffer).uiImage
            }
        }
    }
}
