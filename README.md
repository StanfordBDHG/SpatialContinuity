<!--

This source file is part of the Spatial Continuity project

SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

# Spatial Continuity


## Overview

This repository contains a implementation of _Spatial Continuity_.
_Spatial Continuity_ is a novel concept that proposes a combination of spatial computing and large language models (LLM) to provide seamless transitions between virtual and real-world contexts for making the world more accessible to users with low vision.
Ultimately, this should lead to a truly continuous experience where the friction that accessible technologies introduce, e.g., by setup and positioning, is fully removed. 

This implementation is part of our work on the "Spatial Continuity: Investigating Use Cases of Spatial Computing for Users with Low Vision" poster, which was accepted at the [27th International ACM SIGACCESS Conference on Computers and Accessibility](https://assets25.sigaccess.org/).


## Functionality

The current prototype implementation of _Spatial Continuity_ consists of two apps: the Spatial Continuity app on Vision Pro and the Spatial Continuity Camera app on iPhone.

The Spatial Continuity Camera app functions as a hand-held magnifying glass.
After connecting, it streams the camera feed from the iPhone to the Spatial Continuity Camera app running on Vision Pro.

The Spatial Continuity Camera app can open screenshots from the camera livestream in a separate window for further inspection. 
If an OpenAI API key is provided, spoken image descriptions will be generated as well. 


## Setup and Usage

1. Upon opening the Spatial Continuity app for the first time, you will be presented with the [SpeziLLM](https://github.com/StanfordSpezi/SpeziLLM) onboarding window where you may enter your OpenAI API key. An OpenAI API key is required for generating spoken image descriptions.
2. Ensure that both your iPhone and Vision Pro are on the same network. When opening the Spatial Continuity Camera app on iPhone, the connection should be established automatically.


## Contributors

You can find a list of contributors in the [CONTRIBUTORS.md](/CONTRIBUTORS.md) file.


## Open Source Contributions

As part of this work, we made the following open source contributions:
* https://github.com/apple/swift-openapi-runtime/pull/115
* https://github.com/apple/swift-openapi-generator/pull/625
* https://github.com/openai/openai-openapi/pull/311#issuecomment-2600521373
* https://github.com/StanfordSpezi/SpeziViews/pull/49
* https://github.com/StanfordSpezi/SpeziAccount/pull/82
* https://github.com/StanfordSpezi/SpeziLLM/pull/64
* https://github.com/StanfordSpezi/SpeziViews/pull/43
* https://github.com/StanfordSpezi/SpeziLLM/pull/61


## Contributing

Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/StanfordBDHG/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/StanfordBDHG/.github/blob/main/CODE_OF_CONDUCT.md) first.


## License

This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordBDHG/PediatricAppleWatchStudy/tree/main/LICENSES) for more information.


## Our Research

For more information, check out our website at [biodesigndigitalhealth.stanford.edu](https://biodesigndigitalhealth.stanford.edu).

This project is the result of a collaboration between the Stanford Mussallem Center for Biodesign and the Technical University of Munich.

![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-light.png#gh-light-mode-only)
![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-dark.png#gh-dark-mode-only)
![Technical University of Munich Logo](https://raw.githubusercontent.com/StanfordBDHG/SpatialContinuity/main/assets/tum-logo-light-mode.png#gh-light-mode-only)
![Technical University of Munich Logo](https://raw.githubusercontent.com/StanfordBDHG/SpatialContinuity/main/assets/tum-logo-dark-mode.png#gh-dark-mode-only)
