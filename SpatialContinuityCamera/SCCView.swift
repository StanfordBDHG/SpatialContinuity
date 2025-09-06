//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
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
