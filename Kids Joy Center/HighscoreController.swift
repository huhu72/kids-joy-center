//
//  HighScoreController.swift
//  Kids Joy Center
//
//  Created by Spencer Kinsey-Korzym on 3/29/22.
//

import UIKit

class HighscoreController: UIViewController {
    
    var highscores: [Score] = []
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        highscores = Score.getData()
        highscores = highscores.sorted{ $0.score > $1.score}
        Score.saveData(data: highscores)
    }
    override func viewWillAppear(_ animated: Bool) {
        let btn = UIButton()
        btn.frame = CGRect(x: self.view.frame.width-65, y: 20, width: 60, height: 20)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        setUpView()
    }
    func setUpView(){
        let title = UILabel(frame: CGRect(x: 0, y: 40, width: 133, height: 36))
        title.text = "Highscores"
        title.font = UIFont.systemFont(ofSize: 30.0)
        title.sizeToFit()
        title.center.x = self.view.center.x
        self.view.addSubview(title)
        setUpViewContainer(titleMaxY: title.frame.maxY)

    }
    func setUpViewContainer(titleMaxY: Double){
        let viewContainer = UIView(frame: CGRect(x: 0, y: Int(titleMaxY) + 10, width: 350, height: Int(self.view.frame.height-titleMaxY-10)))
        viewContainer.center.x = self.view.center.x
        self.view.addSubview(viewContainer)
        let max = highscores.count > 5 ? 5 : highscores.count
        for i in 0..<max{
            
            let position = UILabel()
            let name = UILabel()
            let difficulty = UILabel()
            let score = UILabel()
            
            if i == 0{
                position.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            }else{
                position.frame = CGRect(x: 0, y: viewContainer.subviews.last!.frame.maxY + 10, width: 20, height: 20)
            }
            position.text = "\(i+1))"
            position.font = UIFont.systemFont(ofSize: 30.0)
            position.sizeToFit()
            viewContainer.addSubview(position)
            
            name.frame = CGRect(x: position.frame.maxX + 10, y: position.frame.minY, width: 20, height: 20)
            name.text = "\(highscores[i].gameName):"
            name.font = UIFont.systemFont(ofSize: 30.0)
            name.sizeToFit()
            viewContainer.addSubview(name)
            
            difficulty.frame = CGRect(x: name.frame.maxX + 10, y: position.frame.minY, width: 20, height: 20)
            difficulty.text = "\(highscores[i].difficulty)"
            difficulty.font = UIFont.systemFont(ofSize: 30.0)
            difficulty.sizeToFit()
            viewContainer.addSubview(difficulty)
            
            score.frame = CGRect(x: difficulty.frame.maxX + 10, y: position.frame.minY, width: 20, height: 20)
            score.text = "\(highscores[i].score)"
            score.font = UIFont.systemFont(ofSize: 30.0)
            score.sizeToFit()
            viewContainer.addSubview(score)
        }

    }
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)

    }
}


