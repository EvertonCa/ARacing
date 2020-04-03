//
//  OptionsViewController.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var newLabelText: String?
    
    var menuBrains:MenuBrains?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = newLabelText
    }

}
