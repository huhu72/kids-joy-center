//
//  MemoryController.swift
//  Kids Joy Center
//
//  Created by Spencer Kinsey-Korzym on 3/20/22.
//

import UIKit
import AVFoundation

class MemoryController: UIViewController {
    var difficulty: Int!
    let backgroundImage = UIImage(named: "m-background.jpg")
    var background: UIImageView!
    let timer:UIImageView = UIImageView(image: UIImage(named: "time"))
    let minute: UIImageView = UIImageView()
    let seconds0: UIImageView = UIImageView()
    let seconds1: UIImageView = UIImageView()
    let colonLabel: UILabel = UILabel()
    let timerViewContainer: UIView = UIView()
    let score: UIImageView = UIImageView(image: UIImage(named: "score.jpg"))
    let score0: UIImageView = UIImageView()
    let score1: UIImageView = UIImageView()
    let score2: UIImageView = UIImageView()
    var scoreViewContainer: UIView = UIView()
    var scoreContainer: [UIImageView]!
    var timerContainer: [UIImageView]!
    let images: [UIImage] = [UIImage(named: "m-1")!,UIImage(named: "m-2")!,UIImage(named: "m-3")!,UIImage(named: "m-4")!,UIImage(named: "m-5")!,UIImage(named: "m-6")!,UIImage(named: "m-7")!,UIImage(named: "m-8")!,UIImage(named: "m-9")!,UIImage(named: "m-10")!]
    var row1 : [UIImageView]! = []
    var row2 : [UIImageView]! = []
    var row3 : [UIImageView]! = []
    var row4 : [UIImageView]! = []
    var gameViewContainer: UIView = UIView()
    var numCol: Int!
    var gameTimer: Timer!
    var timeRemaining: Int = 0
    var firstClicked : UIImageView!
    var hasFirst = false;
    var secondClicked : UIImageView!
    var hasSecond = false
    var coverTimer: Timer!
    var hasTimerStarted = false
    var imagePool: [UIImage] = []
    var pairsFound: Int = 0
    var alertController: UIAlertController!
    var yesAction: UIAlertAction!
    var noAction: UIAlertAction!
    var audioPlayer: AVAudioPlayer!
    var currentScore: Int! = 0
    var scoreTimer: Timer!
    var scoreTimerCounter: Int = 0
    var matchFound: Bool = false
    var scoreIndeces: [Character] = []
    var imagePoolSize = 10
    var scoreTimerStarted = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGame()
        
    }
    func setUpBackground(){
        background = UIImageView()
        background.image = backgroundImage
        background.contentMode = UIView.ContentMode.scaleAspectFill
        background.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: 1024, height: 698)
        view.addSubview(background)
        background.isUserInteractionEnabled = true
    }
    func setUpTimerView(){
        
        //Left side of the screen
        timer.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        background.addSubview(timer)
        setUpTimerViewContainer()
        
    }
    func setUpTimerViewContainer(){
        timerContainer = [timer, minute, seconds0, seconds1]
        minute.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        minute.image = UIImage(named: "1.jpg")
        minute.restorationIdentifier = "1"
        colonLabel.text = ":"
        colonLabel.frame = CGRect(x: minute.frame.maxX, y: 0, width: 10, height: 25)
        seconds0.frame = CGRect(x: colonLabel.frame.maxX, y: 0, width: 20, height: 30)
        seconds1.frame = CGRect(x: seconds0.frame.maxX, y: 0, width: 20, height: 30)
        timerViewContainer.frame = CGRect(x: timer.frame.maxX, y: 0, width: minute.frame.width + colonLabel.frame.width + seconds0.frame.width + seconds1.frame.width, height: 30)
        for i in 0..<timerContainer.count{
            timerContainer[i].contentMode = UIView.ContentMode.scaleAspectFit
            if i != 0 {
                timerViewContainer.addSubview(timerContainer[i])
            }
        }
        timerViewContainer.backgroundColor = UIColor.lightGray
        colonLabel.font = colonLabel.font.withSize(30)
        timerViewContainer.addSubview(colonLabel)
        background.addSubview(timerViewContainer)
    }
    func setUpScoreView(){
        //Right side of the screen
        scoreContainer = [score0, score1, score2]
        score0.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        score0.image = nil
        score1.frame = CGRect(x: score0.frame.maxX, y: 0, width: 20, height: 30)
        score1.image = nil
        score2.frame = CGRect(x: score1.frame.maxX, y: 0, width: 20, height: 30)
        score2.image = UIImage(named: "0.jpg")
        scoreViewContainer.frame = CGRect(x: background.frame.maxX - 100, y: 0, width: 60, height: 30)
        scoreViewContainer.backgroundColor = UIColor.lightGray
        for i in 0..<scoreContainer.count{
            scoreContainer[i].contentMode = UIView.ContentMode.scaleAspectFit
            scoreViewContainer.addSubview(scoreContainer[i])
        }
        score.frame = CGRect(x: scoreViewContainer.frame.minX-100, y: 0, width: 100, height: 30)
        background.addSubview(score)
        background.addSubview(scoreViewContainer)
    }
    func setUpGame(){
        yesAction = UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.setUpGame()
            /*
             TODO: Save Score, and high score logic
             TODO: Add fireworks to the second clicked and animate it to the score before
             inscreasing the score
             */
        })
        noAction = UIAlertAction(title: "No", style:.default, handler: {_ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alertController = UIAlertController(title: "Congradulations!", message: "Would you like to play again?", preferredStyle: .alert)
        if let oldTimer = scoreTimer{
            oldTimer.invalidate()
        }
        setUpBackground()
        setUpTimerView()
        setUpDifficultyValues()
        pairsFound = 0
        setUpScoreView()
        hasTimerStarted = false
        scoreTimerStarted = false
        row1 = []
        row2 = []
        row3 = []
        row4 = []
        imagePool = []
        gameViewContainer.removeFromSuperview()
        setUpGameImages()
        setUpGameContainer()
        addCover()
        enableInteraction()
        scoreIndeces = []
        currentScore = 0
    }
    
    func setUpGameImages(){
        setUpImagePool()
        for _ in 0..<numCol{
            row1.append(UIImageView(image: getImage()))
            row2.append(UIImageView(image: getImage()))
            row3.append(UIImageView(image: getImage()))
            row4.append(UIImageView(image: getImage()))
        }
        for i in 0..<row1.count{
            row1[i].contentMode = UIView.ContentMode.scaleAspectFit
            row2[i].contentMode = UIView.ContentMode.scaleAspectFit
            row3[i].contentMode = UIView.ContentMode.scaleAspectFit
            row4[i].contentMode = UIView.ContentMode.scaleAspectFit
            if i == 0{
                row1[i].frame = CGRect(x: 0, y: 0, width: 98, height: 98)
                row2[i].frame = CGRect(x: 0, y: row1[i].frame.maxY, width: 98, height: 98)
                row3[i].frame = CGRect(x: 0, y: row2[i].frame.maxY, width: 98, height: 98)
                row4[i].frame = CGRect(x: 0, y: row3[i].frame.maxY, width: 98, height: 98)
            }
            else{
                row1[i].frame = CGRect(x: row1[i-1].frame.maxX , y: 0, width: 98, height: 98)
                row2[i].frame = CGRect(x: row2[i-1].frame.maxX , y: row1[i].frame.maxY , width: 98, height: 98)
                row3[i].frame = CGRect(x: row3[i-1].frame.maxX , y: row2[i].frame.maxY , width: 98, height: 98)
                row4[i].frame = CGRect(x: row4[i-1].frame.maxX , y: row3[i].frame.maxY , width: 98, height: 98)
            }

        }
    }
    func getImage()->UIImage{
        let image = imagePool[Int.random(in: 0..<imagePool.count)]
        imagePool.remove(at: imagePool.firstIndex(of: image)!)
        return image
    }
    func setUpImagePool(){
        
        while(imagePool.count < imagePoolSize){
            let randomImage = images[Int.random(in: 0...9)]
            if(!imagePool.contains(randomImage)){
                imagePool.append(randomImage)
            }
        }
        imagePool.append(contentsOf: imagePool)
        
    }
    func setUpGameContainer(){
        gameViewContainer = UIView()
        var width = 0
        for i in 0..<row1.count{
            width += Int(row1[i].frame.width)
            gameViewContainer.addSubview(row1[i])
            gameViewContainer.addSubview(row2[i])
            gameViewContainer.addSubview(row3[i])
            gameViewContainer.addSubview(row4[i])
        }
        gameViewContainer.frame = CGRect(x: 0, y: 0, width: width, height: 400)
        gameViewContainer.center = background.convert(background.center, from: background.superview)
        background.addSubview(gameViewContainer)
    }
    func addCover(){
        for i in 0..<row1.count{
            row1[i].addSubview(createCover())
            row2[i].addSubview(createCover())
            row3[i].addSubview(createCover())
            row4[i].addSubview(createCover())
            enableInteraction()
        }
        
    }
    func createCover()->UIButton{
        let cover: UIButton = UIButton()
        cover.isHidden = false
        cover.isEnabled = true
        cover.setBackgroundImage(UIImage(named: "m-question.jpg"), for: UIControl.State.normal)
        cover.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        cover.contentMode = UIView.ContentMode.scaleAspectFit
        cover.addTarget(self, action: #selector(coverClicked), for: .touchUpInside)
        return cover
    }
    func enableInteraction(){
        for i in 0..<row1.count{
            row1[i].isUserInteractionEnabled = true
            row2[i].isUserInteractionEnabled = true
            row3[i].isUserInteractionEnabled = true
            row4[i].isUserInteractionEnabled = true
        }
    }
    func disableInteraction(){
        for i in 0..<row1.count{
            row1[i].isUserInteractionEnabled = false
            row2[i].isUserInteractionEnabled = false
            row3[i].isUserInteractionEnabled = false
            row4[i].isUserInteractionEnabled = false
        }
    }
    
    @objc func coverClicked(_ btn: UIButton){
        if(!scoreTimerStarted){
            startScoreTimer()
            scoreTimerStarted = true
        }
        btn.isHidden = true
        if !hasFirst{
            firstClicked = (btn.superview as! UIImageView)
            hasFirst = true
        }else{
            disableInteraction()
            secondClicked = (btn.superview as! UIImageView)
            if(secondClicked.image == firstClicked.image){
                let pathToSound = Bundle.main.path(forResource: "bell", ofType: "mp3")!
                let url = URL(fileURLWithPath: pathToSound)
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer.play()
                }catch{}
                matchFound = true
                getScore()
                pairsFound += 1
                hasFirst = false
                hasSecond = false
                firstClicked = nil
                secondClicked = nil
                enableInteraction()
                if pairsFound == numCol*2{
                    gameTimer.invalidate()
                    yesAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in
                        self.saveData()
                        self.setUpGame()
                    })
                    noAction = UIAlertAction(title: "No", style:.default, handler: {_ in
                        self.saveData()
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                    alertController.addAction(yesAction)
                    alertController.addAction(noAction)
                    present(alertController, animated: true)
                }
            }else{
                coverTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showCover), userInfo: nil, repeats: false)
                
            }
            
        }
        if(!hasTimerStarted){
            
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            hasTimerStarted = true
        }
        
    }
    func pointsAnimation(points: Int){
       let pointsLabel = UILabel()
        pointsLabel.text = "+\(points)"
        print(secondClicked.frame.minY)
        pointsLabel.frame = CGRect(x: 0, y: -50, width: 50, height: 50)
        pointsLabel.center.x = secondClicked.frame.width/2
        pointsLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        
        pointsLabel.sizeToFit()
        secondClicked.addSubview(pointsLabel)
        UILabel.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            pointsLabel.layer.position.y = pointsLabel.frame.minY - 5
        }, completion: { _ in
            pointsLabel.isHidden = true
            pointsLabel.removeFromSuperview()
        })
    }
    func saveData(){
        var highscores = Score.getData()
        highscores.append(Score(name: "Memory", score: self.currentScore, difficulty: self.difficulty))
        Score.saveData(data: highscores)
    }
    func startScoreTimer(){
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownScoreTimer), userInfo: nil, repeats: true)
    }
    func showCovers(){
        let firstCover = firstClicked.subviews[0] as! UIButton
        firstCover.isHidden = false
        firstClicked = nil
        hasFirst = false
        let secondCover = secondClicked.subviews[0] as! UIButton
        secondCover.isHidden = false
        hasSecond = false
        secondClicked = nil
        
    }
    
    @objc func countDownScoreTimer(_ timer: Timer){
        scoreTimerCounter += 1
    }
    
    func getScore(){
        var scoreToBeAdded: Int!
        if(matchFound){
            switch(scoreTimerCounter){
            case 0,1,2,3:
                scoreToBeAdded = 5
            case 4,5,6,7:
                scoreToBeAdded = 4
            default:
                scoreToBeAdded = 3
            }
            currentScore += scoreToBeAdded
            pointsAnimation(points: scoreToBeAdded)
            matchFound = false
            scoreTimerCounter = 1
            scoreIndeces = Array(String(currentScore))
            updateScoreView()
            
        }
    }
    func updateScoreView(){
        switch(scoreIndeces.count){
        case 1:
            score2.image = UIImage(named: "\(scoreIndeces[0]).jpg")
        case 2:
            score2.image = UIImage(named: "\(scoreIndeces[1]).jpg")
            score1.image = UIImage(named: "\(scoreIndeces[0]).jpg")
        case 3:
            score2.image = UIImage(named: "\(scoreIndeces[2]).jpg")
            score1.image = UIImage(named: "\(scoreIndeces[1]).jpg")
            score0.image = UIImage(named: "\(scoreIndeces[0]).jpg")
        default:
            break
        }
    }
    @objc func showCover(){
        showCovers()
        enableInteraction()
    }
    @objc func countDown(){
        
        if timeRemaining > 0{
            timeRemaining -= 1
            //print("less than 120")
            let RID1 = Int(seconds1.restorationIdentifier!)!
            
            if(RID1 > 0){
                seconds1.image = UIImage(named: "\(RID1-1).jpg")
                seconds1.restorationIdentifier = "\(RID1-1)"
            }
            else{
                seconds1.image = UIImage(named: "9.jpg")
                seconds1.restorationIdentifier = "9"
                let RID0 = Int(seconds0.restorationIdentifier!)!
                if(RID0 > 0){
                    seconds0.image = UIImage(named: "\(RID0-1)")
                    seconds0.restorationIdentifier = "\(RID0-1)"
                }else{
                    seconds0.image = UIImage(named: "5.jpg")
                    seconds0.restorationIdentifier = "5"
                    let RID = Int(minute.restorationIdentifier!)!
                    if(RID > 0){
                        minute.image = UIImage(named: "\(RID-1).jpg")
                        minute.restorationIdentifier = "\(RID-1)"
                    }else{
                        minute.image = UIImage(named: "0.jpg")
                        minute.restorationIdentifier = "0"
                    }
                }
                
            }
            
        }else{
            gameTimer.invalidate()
            self.timeRemaining = 0
            self.hasTimerStarted = false
            alertController.title = "You Lost!"
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController,animated: true)
            
        }
        
    }
    func setUpDifficultyValues(){
        switch(difficulty){
        case 0:
            minute.image = UIImage(named: "2.jpg")
            minute.restorationIdentifier = "2"
            seconds0.image = UIImage(named: "0.jpg")
            seconds0.restorationIdentifier = "0"
            seconds1.image = UIImage(named: "0.jpg")
            seconds1.restorationIdentifier = "0"
            //            minute.image = UIImage(named: "0.jpg")
            //            minute.restorationIdentifier = "0"
            //            seconds0.image = UIImage(named: "0.jpg")
            //            seconds0.restorationIdentifier = "0"
            //            seconds1.image = UIImage(named: "1.jpg")
            //            seconds1.restorationIdentifier = "1"
            timeRemaining = 120
            numCol = 3
            imagePoolSize = 6
            
        case 1:
            seconds0.image = UIImage(named: "4.jpg")
            seconds0.restorationIdentifier = "4"
            seconds1.image = UIImage(named: "5.jpg")
            seconds1.restorationIdentifier = "5"
            timeRemaining = 105
            numCol = 4
            imagePoolSize = 8
        case 2:
            seconds0.image = UIImage(named: "3.jpg")
            seconds0.restorationIdentifier = "3"
            seconds1.image = UIImage(named: "0.jpg")
            seconds1.restorationIdentifier = "0"
            timeRemaining = 90
            numCol = 5
        default:
            break
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        if(scoreTimer != nil){
            scoreTimer.invalidate()
        }
        if(gameTimer != nil){
            gameTimer.invalidate()
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
