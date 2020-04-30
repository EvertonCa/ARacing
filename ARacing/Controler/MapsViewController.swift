//
//  TracksViewController.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 30/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

protocol MapViewDelegate: NSObjectProtocol {
    func passMapSelected(mapSelected: Int)
}

class MapsViewController: UIViewController {
    
    // delegate
    weak var delegate: MapViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func map1Pressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.passMapSelected(mapSelected: MapSelected.Map1.rawValue)
        })
    }
    @IBAction func map2Pressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.passMapSelected(mapSelected: MapSelected.Map2.rawValue)
        })
    }
    @IBAction func map3Pressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.passMapSelected(mapSelected: MapSelected.Map3.rawValue)
        })
    }
    
}
