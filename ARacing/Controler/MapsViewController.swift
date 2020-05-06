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
    
    // Maps Collection View
    @IBOutlet weak var mapsCollectionView: UICollectionView!
    
    // delegate
    weak var delegate: MapViewDelegate?
    
    // Game
    var game:Game!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapsCollectionView.dataSource = self
        self.mapsCollectionView.delegate = self
    
    }
}
