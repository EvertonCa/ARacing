//
//  MultiPeerViewController.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 07/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

protocol MultiPeerViewDelegate: NSObjectProtocol {
    func passSelectedConnection(selectedConnection: Int)
}

class MultiPeerViewController: UIViewController {

    // delegate
    weak var delegate: MultiPeerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func hostButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.passSelectedConnection(selectedConnection: Connection.Host.rawValue)
        })
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.passSelectedConnection(selectedConnection: Connection.Join.rawValue)
        })
    }
}
