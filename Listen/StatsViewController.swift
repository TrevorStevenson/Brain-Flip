//
//  StatsViewController.swift
//  Listen
//
//  Created by Jim Stevenson on 6/16/16.
//  Copyright © 2016 TStevenson Apps. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var finalScoreLabel: UILabel!

    @IBOutlet weak var gameOverLabel: UILabel!
    
    var finalScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        finalScoreLabel.text = "Final Score: \(finalScore)"
    }

    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            gameOverLabel.font = UIFont(name: "Avenir-Book", size: 80)
            finalScoreLabel.font = UIFont(name: "Avenir-Book", size: 50)
        }
        
    }
    
    @IBAction func quit(_ sender: AnyObject) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
}
