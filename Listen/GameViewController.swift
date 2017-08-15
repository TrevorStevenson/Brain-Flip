//
//  GameViewController.swift
//  Listen
//
//  Created by Jim Stevenson on 2/28/16.
//  Copyright © 2016 TStevenson Apps. All rights reserved.
//

import UIKit
import Foundation
import GameKit

class GameViewController: UIViewController {

    //outlets
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!

    let beginButton = UIButton()
    
    var directionText = ""
    var currentQuestion: NSDictionary?
    var isBrainFlipped = false
    var currentScore = 0
    var gameTimer = Timer()
    var rand = 0
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.integer(forKey: "firstTime") == 0
        {
            presentInstructions()
            
            UserDefaults.standard.set(1, forKey: "firstTime")
        }
        
        beginButton.frame = CGRect(x: self.view.frame.size.width/2 - (195/2), y: self.view.frame.size.height/2, width: 195, height: 50)
        beginButton.setTitle("Begin", for: UIControlState())
        beginButton.addTarget(self, action: #selector(GameViewController.startGame), for: .touchUpInside)
        beginButton.setTitleColor(UIColor.white, for: UIControlState())
        beginButton.titleLabel?.font = UIFont(name: "Futura", size: 20)
        beginButton.setBackgroundImage(UIImage(named: "Button"), for: UIControlState())
        self.view.addSubview(beginButton)
        
        scoreLabel.text = "Score: \(currentScore)"
        
        progressBar.progress = 1.0
        
        trueButton.isHidden = true
        falseButton.isHidden = true
        
        
        directionLabel.adjustsFontSizeToFitWidth = true

        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            bottomConstraint.constant = 100
        }
        
    }
    
    func presentInstructions()
    {
        let alertView = UIAlertController(title: "Welcome", message: "Brain Flip is a fast-paced game of extreme focus. You will be presented with a number. If the number is black, select whether it is odd or even. If the number is red, select what it is not. For example, the correct answer for a red 7 would be even.", preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
    }

    func startGame()
    {
        beginButton.removeFromSuperview()
        
        trueButton.isHidden = false
        falseButton.isHidden = false
        
        createDirection()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameViewController.updateTimer), userInfo: nil, repeats: true)
        
    }
    
    func updateTimer()
    {
        progressBar.progress -= 1/300
        
        if progressBar.progress <= 0
        {
            endGame()
            gameTimer.invalidate()
            
        }
    }
    
    func endGame()
    {
        
        submitScore()
        
        performSegue(withIdentifier: "stats", sender: self)
        
    }
    
    func submitScore()
    {
        let id: String = "highScore_BF"
        
        let highScore = GKScore(leaderboardIdentifier:id)
        
        highScore.value = Int64(currentScore)
        
        GKScore.report([highScore], withCompletionHandler: { (error:NSError?) -> Void in
            
            if (error != nil)
            {
                print(error!.localizedDescription)
            }
        } as? (Error?) -> Void)
        
    }
    
    func createDirection()
    {
        let randomNumber = arc4random_uniform(2)
        
       // directionText = getTrueFalseQuestion()
        
        rand = Int(arc4random_uniform(100))
        
        directionText = "\(rand)"
        
        if randomNumber == 0
        {
            directionLabel.textColor = UIColor.black
            isBrainFlipped = false
            
        }
        else if randomNumber == 1
        {
            directionLabel.textColor = UIColor.red
            isBrainFlipped = true
        }
        
        directionLabel.text = directionText

        
    }
    
    func getTrueFalseQuestion() -> String
    {
        
        var root: NSDictionary?
        
        var finalQuestion = ""
        
        if let path = Bundle.main.path(forResource: "Data", ofType: "plist")
        {
            root = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = root
        {
            let questionsArray: [NSDictionary] = dict.object(forKey: "TrueFalseQuestions") as! [NSDictionary]
            
            let randomQuestion = arc4random_uniform(UInt32(questionsArray.count))
            
            currentQuestion = questionsArray[Int(randomQuestion)]
            
            if let quest = currentQuestion
            {
                finalQuestion = quest.object(forKey: "Question") as! String
            }
        }
        
        return finalQuestion
    }
    
    @IBAction func answerTrue(_ sender: AnyObject) {
        
        let answer = rand % 2
        
        if answer != 0 && !isBrainFlipped || answer == 0 && isBrainFlipped
        {
            
            currentScore += 10
            
            scoreLabel.text = "Score: \(currentScore)"
            
            createDirection()
            
        }
        else
        {
            
            currentScore -= 10
            
            scoreLabel.text = "Score: \(currentScore)"
            
            createDirection()
        }
        
        
    }
    
    @IBAction func answerFalse(_ sender: AnyObject) {
        
        let answer = rand % 2
        
        if answer == 0 && !isBrainFlipped || answer != 0 && isBrainFlipped
        {
            
            currentScore += 10
            
            scoreLabel.text = "Score: \(currentScore)"
            
            createDirection()
            
        }
        else
        {
            
            currentScore -= 10
            
            scoreLabel.text = "Score: \(currentScore)"
            
            createDirection()
        }

    }
    
    @IBAction func quit(_ sender: AnyObject) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stats"
        {
            let SVC = segue.destination as! StatsViewController
            
            SVC.finalScore = currentScore
            
        }
        
    }

}
