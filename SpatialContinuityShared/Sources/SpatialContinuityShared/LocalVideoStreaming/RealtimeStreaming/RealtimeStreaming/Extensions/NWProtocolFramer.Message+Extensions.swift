//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Network

extension NWProtocolFramer.Message {
    var messageType: MessageType? {
        self["messageType"] as? MessageType
    }

    convenience init(messageType: MessageType) {
        self.init(definition: TLVFramingProtocol.definition)
        self["messageType"] = messageType
    }
}
