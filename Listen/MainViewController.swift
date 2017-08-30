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
    @IBOutlet weak var brain1: UIImageView!
    @IBOutlet weak var brain2: UIImageView!
    @IBOutlet weak var titleWidthConstraint: NSLayoutConstraint!
    
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
            topConstraint.constant = 100
            titleText.font = UIFont(name: "Avenir-Book", size: 100)
            titleWidthConstraint.constant = 500
        }
        
        if self.view.bounds.size.height == 480
        {
            topConstraint.constant = 0
        }
        
        if self.view.bounds.size.height == 568
        {
            topConstraint.constant = 30
        }
    }

    func presentInstructions()
    {
        let alertView = UIAlertController(title: "Welcome", message: "Brain Flip is a fast-paced game of extreme focus. You will be presented with a number. If the number is black, select whether it is odd or even. If the number is red, select the opposite.", preferredStyle: .alert)
        
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
