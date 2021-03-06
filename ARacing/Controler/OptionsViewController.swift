//
//  OptionsViewController.swift
//  ARacing
//
//  Created by Everton Cardoso on 03/04/20.
//  Copyright © 2020 Everton Cardoso. All rights reserved.
//

import UIKit

protocol OptionViewDelegate: NSObjectProtocol {
    func passSelectedOption(selectedOption: Int)
}

class OptionsViewController: UIViewController {
    
    //MARK: - Global IBOutlets and Variables
    
    @IBOutlet weak var singlePlayerButton: UIButton!
    @IBOutlet weak var multiPlayerButton: UIButton!
    @IBOutlet weak var rcModeButton: UIButton!
    
    // delegate
    weak var delegate: OptionViewDelegate?
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - IBActions
    
    // Send to the delegate the selected option and dismisses the view
    @IBAction func singlePlayerPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.passSelectedOption(selectedOption: GameMode.SinglePlayer.rawValue)
        })
    }
    
    
    @IBAction func multiPlayerPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.passSelectedOption(selectedOption: GameMode.MultiPlayer.rawValue)
        })
    }
    
    @IBAction func rcModePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.passSelectedOption(selectedOption: GameMode.RCMode.rawValue)
        })
    }
}
