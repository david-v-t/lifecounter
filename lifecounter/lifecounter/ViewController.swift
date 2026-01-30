//
//  ViewController.swift
//  lifecounter
//
//  Created by iguest on 1/28/26.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lifePointsPlayerOne: UILabel!
    @IBOutlet weak var lifePointsPlayerTwo: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loseLabel.isHidden = true
        playAgainButton.isHidden = true
        lifePointsPlayerOne.text = "20"
        lifePointsPlayerTwo.text = "20"
    }
    
    
    @IBAction func handleLife(for playerLifeLabel: UILabel, sender: UIButton) {
        let currentLife = Int(playerLifeLabel.text!) ?? 20
        
        switch sender.tag {
        case 1: 
            playerLifeLabel.text = "\(currentLife + 1)"
        case 2:
            playerLifeLabel.text = "\(currentLife + 5)"
        case 3:
            playerLifeLabel.text = "\(currentLife - 1)"
        case 4:
            playerLifeLabel.text = "\(currentLife - 5)"
        default:
            break
        }
        
        if let updatedLife = Int(playerLifeLabel.text!), updatedLife <= 0 {
            loseLabel.isHidden = false
            
            if playerLifeLabel == lifePointsPlayerOne {
                loseLabel.text = "Player 1 LOSES!"
            } else {
                loseLabel.text = "Player 2 LOSES!"
            }
            loseLabel.isHidden = false
            playAgainButton.isHidden = false
        }
    }
    
    @IBAction func changePlayerOneLife(_ sender: UIButton) {
        handleLife(for: lifePointsPlayerOne, sender: sender)
    }
    
    @IBAction func changePlayerTwoLife(_ sender: UIButton) {
        handleLife(for: lifePointsPlayerTwo, sender: sender)
    }
    
    
    @IBAction func resetGame(_ sender: UIButton) {
        lifePointsPlayerOne.text = "20"
        lifePointsPlayerTwo.text = "20"
        loseLabel.isHidden = true
        playAgainButton.isHidden = true
    }
}

