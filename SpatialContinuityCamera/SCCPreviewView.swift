//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import UIKit

struct SCCPreviewView: View {
    @Binding var cameraImage: UIImage?
    @Binding var scc: SCC
    @State var videoZoomFactor: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            if let cimg = cameraImage {
                ZStack {
                    Image(uiImage: cimg)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .accessibilityLabel("The viewfinder's view")
                    VStack {
                        Slider(
                            value: $videoZoomFactor,
                            in: scc.minZoom ... scc.maxZoom,
                            minimumValueLabel: Text("\(Int(scc.minZoom))"),
                            maximumValueLabel: Text("\(Int(scc.maxZoom))"),
                            label: { Text("Zoom") }
                        )
                        Text("Zoom")
                    }
                    .frame(width: geometry.size.width - 50, alignment: .center)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 70)
                    .onChange(of: videoZoomFactor) {
                        print(videoZoomFactor)
                        if let videoDevice = scc.videoDevice {
                            do {
                                try videoDevice.lockForConfiguration()
                                videoDevice.videoZoomFactor = videoZoomFactor
                                videoDevice.unlockForConfiguration()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
}
