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
    
    // Vehicles list
    let items = [[VehicleNames.Chiron.rawValue, "Bugatti Chiron", "Track1Icon"],
                  [VehicleNames.Corvette.rawValue, "Chevrolet Corvette C7", "Track1Icon"],
                  [VehicleNames.LancerEvo.rawValue, "Mitsubishi Lancer Evolution X", "Track1Icon"],
                  [VehicleNames.Placeholder1.rawValue, "Placeholder1", "Track1Icon"],
                  [VehicleNames.Placeholder2.rawValue, "Placeholder2", "Track1Icon"]]
    
    // selected item
    var selectedItem:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vehiclesCollectionView.dataSource = self
        self.vehiclesCollectionView.delegate = self
    }
    
}
