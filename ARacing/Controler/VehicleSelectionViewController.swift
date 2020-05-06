//
//  VehicleSelectionViewController.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 02/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

protocol VehicleSelectionDelegate: NSObjectProtocol {
    func passSelectedVehicle(selectedOption: Int)
}

class VehicleSelectionViewController: UIViewController {

    // Vehicle Collection View
    @IBOutlet weak var vehiclesCollectionView: UICollectionView!
    
    // delegate
    weak var delegate: VehicleSelectionDelegate?
    
    // Game
    var game:Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vehiclesCollectionView.dataSource = self
        self.vehiclesCollectionView.delegate = self
    }
    
}
