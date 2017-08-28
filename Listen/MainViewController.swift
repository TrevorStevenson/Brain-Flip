//
//  MainViewController.swift
//  Listen
//
//  Created by Trevor Stevenson on 6/18/16.
//  Copyright © 2016 TStevenson Apps. All rights reserved.
//

import UIKit
import GameKit

class MainViewController: UIViewController, GKGameCenterControllerDelegate {

    var leaderBoardIdentifier: String = "highScore_BF"
    
    var localPlayer = GKLocalPlayer()
    var gameCenterEnabled: Bool = false
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var brain1: UIImageView!
    @IBOutlet weak var brain2: UIImageView!
    @IBOutlet weak var midConstraint: NSLayoutConstraint!
    
    func authenticateLocalPlayer()
    {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController: UIViewController?, error: Error?) in
            
            if let VC = viewController
            {
                self.present(VC, animated: true, completion: nil)
            }
            else
            {
                guard localPlayer.isAuthenticated else { return }
                
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler:nil)
            }
        }
    }
    
    func showLeaderboard(withIdentifier identifier: String)
    {
        let GKVC = GKGameCenterViewController()
        GKVC.gameCenterDelegate = self
        GKVC.viewState = GKGameCenterViewControllerState.leaderboards
        GKVC.leaderboardIdentifier = identifier
        
        present(GKVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        authenticateLocalPlayer()

        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            topConstraint.constant = 150
            titleText.font = UIFont(name: "Futura", size: 100)
            buttonConstraint.constant = 40
            midConstraint.constant = 100
        }
        
        if self.view.bounds.size.height == 480
        {
            brain2.isHidden = true
            
            topConstraint.constant = 20
            
            brain1.frame = CGRect(x: view.frame.size.width/2 - brain1.frame.size.width/2, y: titleText.frame.minY + brain1.frame.size.height, width: brain1.frame.size.width, height: brain1.frame.size.height)
        }
        
        if self.view.bounds.size.height == 568
        {
            brain2.isHidden = true
            
            topConstraint.constant = 30
            
            brain1.frame = CGRect(x: view.frame.size.width/2 - brain1.frame.size.width/2, y: titleText.frame.minY + brain1.frame.size.height + 15, width: brain1.frame.size.width, height: brain1.frame.size.height)
        }
    }

    func presentInstructions()
    {
        let alertView = UIAlertController(title: "Welcome", message: "Brain Flip is a fast-paced game of extreme focus. You will be presented with a number. If the number is black, select whether it is odd or even. If the number is red, select what it is not. For example, the correct answer for a red 7 would be even.", preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func leaderboard(_ sender: AnyObject)
    {
        showLeaderboard(withIdentifier: leaderBoardIdentifier)
        
    }
    
    @IBAction func help(_ sender: AnyObject) {
        
        presentInstructions()
    }

}
