//
//  MapsViewControllerDelegates.swift
//  ARacingPRO
//
//  Created by Everton Cardoso on 06/05/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

//MARK: - UITableViewDataSource

extension MapsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.game.mapImagesResources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! MapsCell
        
        cell.imageView.image = UIImage(named: self.game.mapImagesResources[indexPath.row])
        cell.label.text = self.game.mapNames[indexPath.row]
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension MapsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.passMapSelected(mapSelected: indexPath.row)
        })
    }
}
