//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
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
