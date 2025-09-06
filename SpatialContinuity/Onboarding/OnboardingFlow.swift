//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI

// Source: https://swiftpackageindex.com/stanfordspezi/spezillm/0.8.3/documentation/spezillmopenai

struct OnboardingFlow: View {
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false

    var body: some View {
        OnboardingStack(onboardingFlowComplete: $completedOnboardingFlow) {
            OpenAIAPIKey()
        }
    }
}
