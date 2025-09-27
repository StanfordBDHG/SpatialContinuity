//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct LiveVideoView: View {
    @Binding var currentFrame: UIImage?

    var body: some View {
        GeometryReader { geometry in
            if let currentFrame {
                Image(uiImage: currentFrame)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .accessibilityLabel("The live video being streamed from SpatialContinutiyCamera")
            }
        }
    }
}
