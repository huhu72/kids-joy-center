//
//  ViewController.swift
//  Kids Joy Center
//
//  Created by Spencer Kinsey-Korzym on 3/20/22.
//

import UIKit

class MainController: UIViewController {
    
    @IBOutlet weak var memoryGameBtn: UIButton!
    @IBOutlet weak var sortGameBtn: UIButton!
    @IBOutlet weak var popGameBtn: UIButton!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var widthContraints: [NSLayoutConstraint] = []
    var heightContraits: [NSLayoutConstraint] = []
    var games: [UIButton] = []
    var difficulties: [UIButton] = []
    var isGameSelected: Bool = false
    var isDifficultySelected: Bool = false
    var selectedDifficulty: Int!
    var selectedGame: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        games = [memoryGameBtn, sortGameBtn, popGameBtn]
        difficulties = [easyBtn,mediumBtn,hardBtn]
        for i in 0..<3{
            widthContraints.append(games[i].widthAnchor.constraint(equalToConstant: 250))
            heightContraits.append(games[i].heightAnchor.constraint(equalToConstant: 250))
            NSLayoutConstraint.activate([widthContraints[i],heightContraits[i]])
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gameClicked(_ sender: Any) {
        let btn = sender as! UIButton
        for i in 0..<3{
            self.widthContraints[i].constant =  (i == btn.tag) ? 275 : 250
            self.heightContraits[i].constant =  (i == btn.tag) ? 275 : 250
        }
        selectedGame = btn.tag
        isGameSelected = true
    }
    @IBAction func difficultySelected(_ sender: Any) {
        let btn = sender as! UIButton
        for i in 0..<3{
            difficulties[i].tintColor = (i == btn.tag) ? UIColor.black : UIColor.lightGray
        }
        isDifficultySelected = true
        selectedDifficulty = btn.tag
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier){
        case "memory":
            let destinationVC = segue.destination as! MemoryController
            destinationVC.difficulty = selectedDifficulty!
        case "sort":
            let destinationVC = segue.destination as! SortController
            destinationVC.difficulty = selectedDifficulty!
        case "pop":
            let destinationVC = segue.destination as! PopController
            destinationVC.difficulty = selectedDifficulty!
        default:
            break
        }
        
    }

    @IBAction func gotoGame(_ sender: Any) {
        if isGameSelected && isDifficultySelected{
            switch(selectedGame!){
            case 0 :
                performSegue(withIdentifier: "memory", sender: sender)
            case 1:
                performSegue(withIdentifier: "sort", sender: sender)
            case 2:
                performSegue(withIdentifier: "pop", sender: sender)
            default:
                break
            }
        }
    }
}

