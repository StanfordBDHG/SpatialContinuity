//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import UIKit

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
