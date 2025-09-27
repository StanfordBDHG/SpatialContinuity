//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct SCCView: View {
    @StateObject private var model = SCCModel()

    var body: some View {
        NavigationStack {
            SCCPreviewView(cameraImage: $model.viewFinderImage, scc: $model.scc)
                .task {
                    await model.scc.start()
                }
                .ignoresSafeArea()
        }
    }
}
