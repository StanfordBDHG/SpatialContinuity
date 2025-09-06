//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
@_exported import SpatialContinuityShared

@main
struct SpatialContinuityCameraApp: App {
    var body: some Scene {
        WindowGroup {
            SCCView()
        }
    }
}
