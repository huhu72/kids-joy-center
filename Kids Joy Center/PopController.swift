//
//  PopController.swift
//  Kids Joy Center
//
//  Created by Spencer Kinsey-Korzym on 3/20/22.
//

/*
 **Only spawn from bottom
 current function that needs verification:
 
 balloons spawn one time every second from both the top and bot
 bonus/killer ballons will only spawn from the top
 bonus balloon will spawn causes both top and bottom spawns to be slowed down
 
 */

import UIKit
import AVFoundation

class PopController: UIViewController {
    var difficulty: Int!
    var background: UIImageView!
    let backgroundImage: UIImage = UIImage(named: "sky.jpg")!
    let time: UIImageView = UIImageView(image: UIImage(named: "time.jpg"))
    var timerContainer : [UIImageView] = []
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
    var timeRemaining: Int!
    var upperBallonNumRange: Int!
    var balloonSpeed: Double!
    var balloonPool: [UIImage]!
    var numOfBalloonSpawn: Int!
    var pointsPool: [UIImage]!
    var gameTimer: Timer!
    var balloonAnimationTimer: Timer!
    var timerArray: [Timer]!
    var slowedTimer: Timer!
    var balloons: [UIButton]!
    var slowBalloons: [UIButton]!
    var currentScore: Int!
    var scoreIndeces: [Character]!
    var alertController: UIAlertController!
    var yesAction: UIAlertAction!
    var noAction: UIAlertAction!
    var compairingScore: Int!
    var animation: CABasicAnimation!
    var hasAnimationStarted: Bool!
    var bonusBalloonTimerCounter: Int!
    var killerBalloonTimerCounter: Int!
    var randomBonusCounter: Int!
    var randomKillerCounter: Int!
    var slowedBalloonTimeCounter: Int!
    var slowedBalloonSpeed: Double!
    var spawningSlowBalloons: Bool!
    var audioPlayer: AVAudioPlayer!
    var yCord: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGame()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setUpGame(){
        alertController = UIAlertController(title: "Congradulations!", message: "Would you like to play again?", preferredStyle: .alert)
        yesAction = UIAlertAction(title: "Yes", style: .default, handler: {_ in self.setUpGame() })
        noAction = UIAlertAction(title: "No", style: .default, handler: { _ in self.navigationController!.popViewController(animated: true)})
        hasAnimationStarted = false
        spawningSlowBalloons = false
        killerBalloonTimerCounter = 1
        bonusBalloonTimerCounter = 1
        slowedBalloonTimeCounter = 1
        //        randomBonusCounter = Int.random(in: 2...3)
        //        randomKillerCounter = Int.random(in: 2...3)
        randomBonusCounter = Int.random(in: 20...25)
        randomKillerCounter = Int.random(in: 20...25)
        balloons = []
        slowBalloons = []
        timerArray = []
        currentScore = 0
        setUpBackground()
        yCord = Int(background.frame.height)
        setUpTimerView()
        setUpScoreView()
        setUpDifficultyValues()
        createAnimation()
        setUpBalloonPool()
        setUpPointsPool()
        startGameTimer()
        // spawnBalloon(type: "score")
        
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
        time.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        background.addSubview(time)
        setUpTimerViewContainer()
        
    }
    func setUpTimerViewContainer(){
        timerContainer = [time, minute, seconds0, seconds1]
        minute.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        minute.image = UIImage(named: "0.jpg")
        minute.restorationIdentifier = "0"
        colonLabel.text = ":"
        colonLabel.frame = CGRect(x: minute.frame.maxX, y: 0, width: 10, height: 25)
        seconds0.frame = CGRect(x: colonLabel.frame.maxX, y: 0, width: 20, height: 30)
        seconds1.frame = CGRect(x: seconds0.frame.maxX, y: 0, width: 20, height: 30)
        timerViewContainer.frame = CGRect(x: time.frame.maxX, y: 0, width: minute.frame.width + colonLabel.frame.width + seconds0.frame.width + seconds1.frame.width, height: 30)
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
    func setUpDifficultyValues(){
        switch(difficulty){
        case 0:
            minute.image = UIImage(named: "1.jpg")
            minute.restorationIdentifier = "1"
            seconds0.image = UIImage(named: "0.jpg")
            seconds0.restorationIdentifier = "0"
            seconds1.image = UIImage(named: "0.jpg")
            seconds1.restorationIdentifier = "0"
            timeRemaining = 60
            upperBallonNumRange = 9
            balloonSpeed = 4/4
            numOfBalloonSpawn = 0
            
            
        case 1:
            seconds0.image = UIImage(named: "4.jpg")
            seconds0.restorationIdentifier = "4"
            seconds1.image = UIImage(named: "5.jpg")
            seconds1.restorationIdentifier = "5"
            timeRemaining = 45
            upperBallonNumRange = 7
            balloonSpeed = 5.1125/4.0
            numOfBalloonSpawn = 2
            
            
        case 2:
            seconds0.image = UIImage(named: "3.jpg")
            seconds0.restorationIdentifier = "3"
            seconds1.image = UIImage(named: "0.jpg")
            seconds1.restorationIdentifier = "0"
            timeRemaining = 30
            upperBallonNumRange = 5
            balloonSpeed = 7.8167/4.0
            numOfBalloonSpawn = 3
        default:
            break
        }
        slowedBalloonSpeed = balloonSpeed/2
        
    }
    func createAnimation(){
        animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = time.frame.maxY
        animation.toValue = 1
    }
    func setUpBalloonPool(){
        balloonPool = []
        for i in 1...10{
            balloonPool.append(UIImage(named: "b\(i).jpg")!)
        }
    }
    func setUpPointsPool(){
        pointsPool = []
        for i in 0...9{
            pointsPool.append(UIImage(named: "\(i).jpg")!)
        }
    }
    func startGameTimer(){
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        timerArray.append(gameTimer)
        
    }
    @objc func countDown(){
        
        if timeRemaining > 0{
            spawnBalloon(type: "score")
            spawnExtraBalloon()
            timeRemaining -= 1
            spawnBonusBalloons()
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
            if self.timeRemaining == 11 {
                compairingScore = currentScore
            }
            if timeRemaining < 10{
                if currentScore == compairingScore{
                    gameTimer.invalidate()
                    balloonAnimationTimer.invalidate()
                    self.timeRemaining = 0
                    alertController.title = "You Lost!"
                    alertController.addAction(yesAction)
                    alertController.addAction(noAction)
                    present(alertController,animated: true)
                }
            }
            bonusBalloonTimerCounter += 1
            killerBalloonTimerCounter += 1
            
        }else{
            gameTimer.invalidate()
            balloonAnimationTimer.invalidate()
            self.timeRemaining = 0
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
            present(alertController,animated: true)
            
        }
        
    }
    func saveData(){
        var highscores = Score.getData()
        highscores.append(Score(name: "Balloon", score: self.currentScore, difficulty: self.difficulty))
        Score.saveData(data: highscores)
    }
    func spawnBalloon(type: String){
        let balloon = UIButton()
        var subView: UIImageView!
        let randomPointsPoolIndex = Int.random(in: 1...upperBallonNumRange)
        let randomXCord = Int.random(in: 0...(1024-60))
        
        balloon.setBackgroundImage(balloonPool[Int.random(in: 0...9)], for: .normal)
        balloon.frame = CGRect(x: randomXCord, y: yCord, width: 60, height: 80)
        if(type == "score"){
            subView = UIImageView(image: pointsPool[randomPointsPoolIndex])
            subView.restorationIdentifier = "\(randomPointsPoolIndex)"
        }else{
            subView = UIImageView(image: UIImage(named: "\(type).jpg"))
            subView.restorationIdentifier = type
        }
        balloon.contentMode = UIView.ContentMode.scaleAspectFit
        subView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        subView.contentMode = UIView.ContentMode.scaleAspectFit
        subView.center = CGPoint(x: balloon.frame.width/2, y: balloon.frame.height/2)
        balloon.isUserInteractionEnabled = true
        balloon.frame = checkForBalloonIntersection(balloon: balloon, balloonArray: balloons)
        balloon.addSubview(subView)
        balloon.addTarget(self, action: #selector(pop), for: .touchUpInside)
        if !spawningSlowBalloons{
            balloons.append(balloon)
        }else{
            if(type == "score"){
                slowBalloons.append(balloon)
            }
        }
        if(!hasAnimationStarted){
            startAnimation()
            hasAnimationStarted = true
        }
        background.addSubview(balloon)
    }
    func checkForBalloonIntersection(balloon: UIButton, balloonArray: [UIButton])->CGRect{
        for b in balloonArray{
            while(balloon.frame.intersects(b.frame)){
                let randomXCord = Int.random(in: 0...(1024-60))
                balloon.frame = CGRect(x: randomXCord, y: yCord, width: 60, height: 80)
            }
        }
        return balloon.frame
    }
    func spawnExtraBalloon(){
        if numOfBalloonSpawn != 0{
            for _ in 1 ..< numOfBalloonSpawn{
                let spawnChance = Int.random(in: 1...numOfBalloonSpawn)
                if spawnChance == 1{
                    spawnBalloon(type: "score")
                }
            }
        }
    }
    @objc func pop(_ balloon: UIButton){
        let pathToSound = Bundle.main.path(forResource: "pop", ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        }catch{}
        //balloon.isHidden = true
        if(balloon.subviews.last!.restorationIdentifier! == "bonus"){
            spawningSlowBalloons = true
            slowedTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementSlowedTimer), userInfo: nil, repeats: true)
            timerArray.append(slowedTimer)
        }else if balloon.subviews.last!.restorationIdentifier! == "killer"{
            for timer in timerArray {
                if timer.isValid{
                    timer.invalidate()
                }
            }
            alertController.title = "You Lost!"
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true)
        }else{
            pointsAnimation(balloon: balloon )
        }
        balloon.isHidden = true
    }
    func pointsAnimation(balloon: UIButton){
        let animatedPoint = UIImageView(image: UIImage(named: "\(balloon.subviews.last!.restorationIdentifier!).jpg"))
        animatedPoint.frame = CGRect(x: balloon.frame.origin.x, y: balloon.frame.origin.y, width: 20, height: 20)
        animatedPoint.center = balloon.center
        background.addSubview(animatedPoint)
        UIImageView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            animatedPoint.frame.origin.x = self.scoreViewContainer.frame.maxX-20
            animatedPoint.frame.origin.y = self.scoreViewContainer.frame.maxY-25
        }, completion: {
            _ in
            animatedPoint.removeFromSuperview()
            self.increaseScore(points: balloon.subviews.last!.restorationIdentifier!)
        })
        
    }
    @objc func incrementSlowedTimer(){
        if slowedBalloonTimeCounter == 5{
            spawningSlowBalloons = false
            slowedBalloonTimeCounter = 1
            slowedTimer.invalidate()
        }
        slowedBalloonTimeCounter += 1
    }
    func startAnimation(){
        balloonAnimationTimer = Timer.scheduledTimer(timeInterval: (0.125/4.0), target: self, selector: #selector(moveBalloon), userInfo: nil, repeats: true)
        timerArray.append(balloonAnimationTimer)
    }
    @objc func moveBalloon(){
        if slowBalloons.count != 0{
            for slowBalloon in slowBalloons{
                if(slowBalloon.frame.maxY >= 798 ){
                    slowBalloon.frame.origin.y -= balloonSpeed
                }else{
                    slowBalloon.frame.origin.y -= slowedBalloonSpeed
                    if(slowBalloon.frame.minY <= time.frame.maxY){
                        slowBalloons.remove(at: slowBalloons.firstIndex(of: slowBalloon)!)
                        slowBalloon.removeFromSuperview()
                    }
                }
            }
        }
        for balloon in balloons {
            
            if balloon.frame.origin.y > time.frame.maxY{
                if balloon.subviews.last!.restorationIdentifier == "bonus" || balloon.subviews.last!.restorationIdentifier == "killer"{
                    balloon.frame.origin.y -= balloonSpeed + 2
                }else{
                    balloon.frame.origin.y -= balloonSpeed
                }
            }
            else{
                balloons.remove(at: balloons.firstIndex(of: balloon)!)
                balloon.removeFromSuperview()
            }
        }
    }
    
    func spawnBonusBalloons(){
        if( bonusBalloonTimerCounter == randomBonusCounter){
            bonusBalloonTimerCounter = 1
            randomBonusCounter = Int.random(in: 20...25)
            spawnBalloon(type: "bonus")
        }
        else if killerBalloonTimerCounter == randomKillerCounter{
            killerBalloonTimerCounter = 1
            randomKillerCounter = Int.random(in: 20...25)
            spawnBalloon(type: "killer")
        }
    }
    
    
    func increaseScore(points: String){
        currentScore += Int(points)!
        scoreIndeces = Array(String(currentScore))
        updateScoreView()
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        for timer in timerArray{
            if timer.isValid{
                timer.invalidate()
            }
        }
    }
    
    
}
