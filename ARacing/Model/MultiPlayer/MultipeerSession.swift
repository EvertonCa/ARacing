//
//  MultipeerSession.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 06/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//
//  This Class manages the Multi-peer connectivity for multiplayer game mode

import MultipeerConnectivity

protocol MultipeerSessionDelegate {
    
    func connectedDevicesChanged(manager : MultipeerSession, connectedDevices: [String])
    func messageReceived(manager : MultipeerSession, message: Message)
    
}

class MultipeerSession: NSObject {
    
    //MARK: - Variables and Constants
    
    // AR View Controller
    var arViewController:ARViewController
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    static let serviceType = "eca-aracing"
    
    // Peer name as device name
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    // Session control variables
    private var session: MCSession!
    private var advertiserAssistant: MCAdvertiserAssistant!
    private var browserAssistant: MCBrowserViewController!
    
    // Delegate
    var delegate:MultipeerSessionDelegate?
    
    //MARK: - Functions
    
    // Init and initial setup
    init(view:ARViewController) {
        
        self.arViewController = view
        
        self.session = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: .required)
        
        super.init()
        
        self.session.delegate = self
    }
    
    // Sets the device as Host in the Multipeer Connectivity
    func startHosting(action: UIAlertAction) {
        self.advertiserAssistant = MCAdvertiserAssistant(serviceType: MultipeerSession.serviceType, discoveryInfo: nil, session: self.session)
        self.advertiserAssistant.start()
    }
    
    // Sets the device as Client in the Multipeer Connectivity and shows the view to choose connection
    func joinSession(action: UIAlertAction) {
        self.browserAssistant = MCBrowserViewController(serviceType: MultipeerSession.serviceType, session: self.session)
        self.browserAssistant?.delegate = self
        self.arViewController.present(self.browserAssistant, animated:true)
    }
    
    // Stops advertising as Host
    func stopAdvertisingHosting() {
        self.advertiserAssistant.stop()
    }
    
    // Encodes and sends the desired message to the connected peers
    func encodeAndSend(message:Message) {
        if let encodedMessage = self.encodeMessage(message: message) {
            self.sendMessage(data: encodedMessage)
        }
    }
    
    // Encode the message to Data format
    func encodeMessage(message:Message) -> Data? {
        let encoder = JSONEncoder()
        var encoded:Data?
        do {
            encoded = try encoder.encode(message)
        } catch {
            print(error.localizedDescription)
        }
        return encoded
    }
    
    // Sends the data to connected peers
    func sendMessage(data:Data) {
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // Decodes the message
    func decodeMessage(data:Data) -> Message {
        let decoder = JSONDecoder()
        var decoded:Message!
        do {
            decoded = try decoder.decode(Message.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        return decoded
    }
}

//MARK: - MCSessionDelegate

extension MultipeerSession: MCSessionDelegate {
    
    // Handles new peers
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    // Handles data received
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        self.delegate?.messageReceived(manager: self, message: self.decodeMessage(data: data))
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        fatalError("This service does not send/receive streams.")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        fatalError("This service does not send/receive resources.")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        fatalError("This service does not send/receive resources.")
    }
    
}

//MARK: - MCBrowserViewControllerDelegate

// Handles connection browser
extension MultipeerSession: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.arViewController.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.arViewController.dismiss(animated: true)
    }
    
    
}


