//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

@_exported import SpatialContinuityShared
import SwiftUI

@main
struct SpatialContinuityCameraApp: App {
    var body: some Scene {
        WindowGroup {
            SCCView()
        }
    }
}
