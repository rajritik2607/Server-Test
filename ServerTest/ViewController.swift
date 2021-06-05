//
//  ViewController.swift
//  ServerTest
//
//  Created by Ritik Suryawanshi on 05/06/21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        styleHollowButton(startButton)
        // Do any additional setup after loading the view.
    }

    func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.green.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.green
    }
}

