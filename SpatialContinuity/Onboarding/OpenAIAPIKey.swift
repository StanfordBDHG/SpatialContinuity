//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import SpeziLLMOpenAI
import SpeziOnboarding
import SwiftUI

// Source: https://swiftpackageindex.com/stanfordspezi/spezillm/0.8.3/documentation/spezillmopenai

struct OpenAIAPIKey: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath: OnboardingNavigationPath

    var body: some View {
        LLMOpenAIAPITokenOnboardingStep {
            onboardingNavigationPath.nextStep()
        }
    }
}
