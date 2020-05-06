//
//  VehicleSelectionViewControllerDelegates.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 02/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

//MARK: - UITableViewDataSource
extension VehicleSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.game.vehiclesImagesResources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! VehicleCell
        
        cell.imageView.image = UIImage(named: self.game.vehiclesImagesResources[indexPath.row] )
        
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegate

extension VehicleSelectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.passSelectedVehicle(selectedOption: indexPath.row)
            
        })
    }
}

