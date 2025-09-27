//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
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
