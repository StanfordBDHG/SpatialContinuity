//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziLLM
import SpeziLLMOpenAI

class LLMOpenAIAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration {
            LLMRunner {
                LLMOpenAIPlatform()
            }
        }
    }
}
