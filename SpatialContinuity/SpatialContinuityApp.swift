//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_exported import SpatialContinuityShared
import Spezi
import SpeziViews
import SwiftUI

@main
struct SpatialContinuityApp: App {
    @ApplicationDelegateAdaptor(LLMOpenAIAppDelegate.self) var appDelegate
    @StateObject private var model: SCModel = .init()
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var pinWindowOpen: Bool = false

    var body: some Scene {
        WindowGroup(id: "livestream") {
            ZStack {
                if completedOnboardingFlow {
                    LiveVideoView(currentFrame: $model.currentFrame)
                        .onDisappear {
                            dismissWindow(id: "currentPin")
                        }
                } else {
                    EmptyView()
                }
            }
            .sheet(isPresented: !$completedOnboardingFlow) {
                OnboardingFlow()
            }
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    Button(String(localized: "API Key Settings")) {
                        completedOnboardingFlow.toggle()
                    }
                }
                ToolbarItem(placement: .bottomOrnament) {
                    Button(String(localized: "Read Image Description")) {
                        model.currentPin = model.currentFrame
                        if !pinWindowOpen {
                            openWindow(id: "currentPin")
                        }
                    }
                    .disabled(!model.networking.isConnected)
                }
            }
            .spezi(appDelegate)
        }
        .windowResizability(.contentSize)

        WindowGroup("Current Pin", id: "currentPin") {
            ZStack {
                if completedOnboardingFlow {
                    StaticPinView(img: $model.currentPin)
                        .onAppear {
                            pinWindowOpen = true
                        }
                        .onDisappear {
                            pinWindowOpen = false
                        }
                }
            }
            .spezi(appDelegate)
        }
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            guard let contentWindow = context.windows.first(where: { $0.id == "livestream" })
            else {
                return WindowPlacement(nil)
            }
            return WindowPlacement(.trailing(contentWindow))
        }
    }
}
