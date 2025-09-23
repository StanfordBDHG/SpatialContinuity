//
// This source file is part of the Spatial Continuity project
//
// SPDX-FileCopyrightText: 2024 Paul Heidekrüger
//
// SPDX-License-Identifier: MIT
//

// References:
// * https://www.ralfebert.com/ios-app-development/multipeer-connectivity/
// * https://www.hackingwithswift.com/example-code/networking/how-to-create-a-peer-to-peer-network-using-the-multipeer-connectivity-framework

import MultipeerConnectivity
import SwiftUI

class SCCPeerConnection: NSObject, ObservableObject {
    private let peerID: MCPeerID = .init(displayName: UIDevice.current.name)
    private let mcSession: MCSession
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceType = "SCCBonj"

    override init() {
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)

        super.init()

        mcSession.delegate = self
        serviceAdvertiser.delegate = self

        serviceAdvertiser.startAdvertisingPeer()
    }

    func sendImage(data: Data?) {
        if !mcSession.connectedPeers.isEmpty {
            do {
                if let data {
                    try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                }
            } catch {
                print("Couldn't send image")
            }
        } else {
            print("Connected peers are empty")
        }
    }

    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
    }
}

extension SCCPeerConnection: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("advertising error: \(String(describing: error))")
    }

    func advertiser(
        _: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext _: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        // HACK: We unconditonally accept connections
        print("Peer invitiaton received from \(peerID)")
        invitationHandler(true, mcSession)
    }
}

extension SCCPeerConnection: MCSessionDelegate {
    func session(_: MCSession, peer _: MCPeerID, didChange _: MCSessionState) {}

    func session(_: MCSession, didReceive _: Data, fromPeer _: MCPeerID) {}

    func session(_: MCSession, didReceive _: InputStream, withName _: String, fromPeer _: MCPeerID) {}

    func session(_: MCSession, didStartReceivingResourceWithName _: String, fromPeer _: MCPeerID, with _: Progress) {}

    func session(
        _: MCSession,
        didFinishReceivingResourceWithName _: String,
        fromPeer _: MCPeerID,
        at _: URL?,
        withError _: Error?
    ) {}
}
