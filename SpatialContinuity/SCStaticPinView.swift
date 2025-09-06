//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

import AVFoundation
import SpeziLLM
import SpeziLLMOpenAI
import SwiftUI

struct StaticPinView: View {
    @State var llmSession: LLMOpenAISession?
    @State var responseText = ""
    @Binding var img: UIImage?
    @Environment(LLMRunner.self) var runner
    @State var synthesizer: AVSpeechSynthesizer = .init()

    var body: some View {
        GeometryReader { geometry in
            if let img {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .accessibilityLabel("The static pin received from SpatialContinuityCamera")
                    .onAppear {
                        if llmSession == nil {
                            setUpLLMSession()
                        }
                    }
                    .task(id: img) {
                        do {
                            if let llmSession {
                                await MainActor.run {
                                    llmSession.context.append(
                                        userInput: "Please describe this image in German",
                                        userImgInput: img
                                    )
                                }

                                for try await token in try await llmSession.generate() {
                                    responseText.append(token)
                                }

                                readDescription()
                            }
                        } catch {
                            print("Didn't receive a response from the OpenAI API \(error)")
                        }
                    }
            } else {
                Text("Your pin will appear here.")
            }
        }
    }

    private func readDescription() {
        let description = AVSpeechUtterance(string: responseText)
        description.prefersAssistiveTechnologySettings = true
        description.rate = 0.6
        synthesizer.speak(description)
        responseText.removeAll()
    }

    private func setUpLLMSession() {
        llmSession = runner(
            with: LLMOpenAISchema(
                parameters: .init(
                    modelType: .init(value1: .gpt4_turbo, value2: .gpt_hyphen_4_hyphen_turbo),
                    systemPrompt: "You are an assistant that describes images to users with visual impairments."
                )
            )
        )
    }
}
