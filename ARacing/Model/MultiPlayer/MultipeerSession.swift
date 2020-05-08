//
//  MultipeerSession.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 06/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//
//  This Class manages the Multi-peer connectivity for multiplayer game mode

import MultipeerConnectivity
import ARKit

protocol MultipeerSessionDelegate {
    
    func messageReceived(manager : MultipeerSession, message: Message)
}

class MultipeerSession: NSObject {
    
    //MARK: - Variables and Constants
    
    // Bool to check if the map can be sent
    var canSendMap = false
    
    // AR View Controller
    var arViewController:ARViewController
    
    // Multi AR Brain
    var multiBrain:MultiARBrains
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    static let serviceType = "eca-aracing"
    
    // Peer name as device name
    let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    // Session control variables
    private var session: MCSession!
    private var advertiserAssistant: MCAdvertiserAssistant!
    private var browserAssistant: MCBrowserViewController!
    
    // Delegate
    var delegate:MultipeerSessionDelegate?
    
    // Connected Peers
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
    
    // Map Provider
    var mapProvider: MCPeerID?
    
    //MARK: - Functions
    
    // Init and initial setup
    init(view:ARViewController, multiBrain:MultiARBrains) {
        
        self.arViewController = view
        self.multiBrain = multiBrain
        
        self.session = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: .required)
        
        super.init()
        
        self.session.delegate = self
    }
    
    // Sets the device as Host in the Multipeer Connectivity
    func startHosting() {
        self.advertiserAssistant = MCAdvertiserAssistant(serviceType: MultipeerSession.serviceType, discoveryInfo: nil, session: self.session)
        self.advertiserAssistant.start()
    }
    
    // Sets the device as Client in the Multipeer Connectivity and shows the view to choose connection
    func joinSession() {
        self.browserAssistant = MCBrowserViewController(serviceType: MultipeerSession.serviceType, session: self.session)
        self.browserAssistant?.delegate = self
        
        self.browserAssistant.modalPresentationStyle = .overCurrentContext
        self.arViewController.present(self.browserAssistant, animated:true)
    }
    
    // Stops advertising as Host
    func stopAdvertisingHosting() {
        self.advertiserAssistant.stop()
    }
    
    // Encodes and sends the desired message to the connected peers
    func encodeAndSend(message:Message) {
        if let encodedMessage = self.encodeMessage(message: message) {
            self.sendData(data: encodedMessage)
        }
    }
    
    // Encode the message to Data format
    private func encodeMessage(message:Message) -> Data? {
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
    private func sendData(data:Data) {
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // Encode ARWorldMap
    func encodeARWorldMap(worldMap:ARWorldMap) -> Data {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
            else { fatalError("can't encode map") }
        return data
    }
    
    // Handles Received Data
    func receiveData(_ data: Data, from peer: MCPeerID){
        let decoder = JSONDecoder()
        let decodedMessage = try! decoder.decode(Message.self, from: data)
        
        if decodedMessage.messageType == MessageType.ARWorldMapAndTransformMatrix.rawValue{
            self.mapProvider = peer
        }
        
        self.delegate?.messageReceived(manager: self, message: decodedMessage)
    }
}

//MARK: - MCSessionDelegate

extension MultipeerSession: MCSessionDelegate {
    
    // Handles new peers
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            
            // Displays the Peer Name in the screen
            DispatchQueue.main.async {
                self.arViewController.connectedWith(message: "Connected: \(peerID.displayName)")
            }
            
            // If device is host, will send ARWorldMap and Transform Matrix to new peer
            if self.arViewController.game.multipeerConnectionSelected == Connection.Host.rawValue {
                
                // Encode and send the message with the ARWorld Map and the transform information for the Map
                self.encodeAndSend(message: self.multiBrain.messageARWorldMap())
                
                // Enables the start button
                self.arViewController.showStartButton()
            }
            // If device is client, will send vehicle selected
            else{
                self.encodeAndSend(message: self.multiBrain.messageVehicleSelected())
            }
        case .connecting:
            DispatchQueue.main.async {
                self.arViewController.connectedWith(message: "Connecting: \(peerID.displayName)")
            }
        case .notConnected:
            if self.arViewController.game.multipeerConnectionSelected == Connection.Host.rawValue{
                // removes the peer from the game list
                if let indexToRemove = self.arViewController.game.peersHashIDs.firstIndex(of: peerID.hash) {
                    self.arViewController.game.peersHashIDs.remove(at: indexToRemove)
                    self.arViewController.game.listSelectedVehicles.remove(at: indexToRemove)
                    self.arViewController.game.peersQuantity -= 1
                }
            }
            DispatchQueue.main.async {
                self.arViewController.connectedWith(message: "Not Connected: \(peerID.displayName)")
            }
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    // Handles data received
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        self.receiveData(data, from: peerID)
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
        self.arViewController.dismiss(animated: true, completion: {
            self.arViewController.multiARBrain?.loadReceivedARWorldMap()
        })
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.arViewController.dismiss(animated: true, completion: {
            self.arViewController.goToMultiPeerViewController()
        })
    }
}


