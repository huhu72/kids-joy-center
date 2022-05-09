//
//  SortController.swift
//  Kids Joy Center
//
//  Created by Spencer Kinsey-Korzym on 3/20/22.
//

import UIKit
import AVFoundation

class SortController: UIViewController {
    var difficulty: Int!
    var background: UIImageView = UIImageView()
    let backgroundImage: UIImage = UIImage(named: "sorting-background.jpg")!
    var vehicleView: UIView = UIView()
    var imagePool: [CustomUIImageView] = [
        CustomUIImageView(Categories.air,"air-1.jpg"),
        CustomUIImageView(Categories.air, "air-2.jpg"),
        CustomUIImageView(Categories.air, "air-3.jpg"),
        CustomUIImageView(Categories.air, "air-4.jpg"),
        CustomUIImageView(Categories.air, "air-5.jpg"),
        CustomUIImageView(Categories.land, "land-1.jpg"),
        CustomUIImageView(Categories.land, "land-2.jpg"),
        CustomUIImageView(Categories.land, "land-3.jpg"),
        CustomUIImageView(Categories.land, "land-4.jpg"),
        CustomUIImageView(Categories.land, "land-5.jpg"),
        CustomUIImageView(Categories.water, "water-1.jpg"),
        CustomUIImageView(Categories.water, "water-2.jpg"),
        CustomUIImageView(Categories.water, "water-3.jpg"),
        CustomUIImageView(Categories.water, "water-4.jpg"),
        CustomUIImageView(Categories.water, "water-5.jpg")]
    var vehicleViewContainer: UIView = UIView()
    var vehicles: [CustomUIImageView] = []
    var numVehicles: Int = 0
    var imageWidth = 0
    let air = UIView()
    let waterTop = UIView()
    let waterBottom = UIView()
    let landTop = UIView()
    let landBottom = UIView()
    var panGR: UIPanGestureRecognizer!
    var vehicleOrigin: CGPoint!
    var currentScore = 0
    let timerViewContainer: UIView = UIView()
    var timerContainer: [UIImageView]!
    let timer:UIImageView = UIImageView(image: UIImage(named: "time"))
    let minute: UIImageView = UIImageView()
    let seconds0: UIImageView = UIImageView()
    let seconds1: UIImageView = UIImageView()
    let colonLabel: UILabel = UILabel()
    var scoreContainer: [UIImageView]!
    var scoreViewContainer: UIView = UIView()
    let score: UIImageView = UIImageView(image: UIImage(named: "score.jpg"))
    let score0: UIImageView = UIImageView()
    let score1: UIImageView = UIImageView()
    let score2: UIImageView = UIImageView()
    var timeRemaining = 60
    var hasTimerStarted: Bool = false
    var gameTimer: Timer!
    var alertController: UIAlertController!
    var yesAction: UIAlertAction!
    var noAction: UIAlertAction!
    var isFirstFound: Bool!
    var scoreTimer: Timer!
    var isCorrect: Bool! = false
    var scoreTimerCounter: Int! = 1
    var scoreIndeces: [Character] = []
    var audioPlayer: AVAudioPlayer!
    var pointsToBeAdded = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGame()
        
    }
    func setUpGame(){
        alertController = UIAlertController(title: "Congradulations!", message: "Would you like to play again?", preferredStyle: .alert)
        yesAction = UIAlertAction(title: "Yes", style: .default, handler: {_ in self.setUpGame() })
        noAction = UIAlertAction(title: "No", style: .default, handler: { _ in self.navigationController!.popViewController(animated: true)})
        if let oldTimer = scoreTimer{
            oldTimer.invalidate()
        }
        vehicleViewContainer.removeFromSuperview()
        scoreTimerCounter = 1
        hasTimerStarted = false
        vehicles = []
        currentScore = 0
        setUpBackground()
        setUpCategoryBounds()
        setUpTimerView()
        setUpDifficultyValues()
        setUpVehicleView()
        setUpScoreView()

    }
    func setUpCategoryBounds(){
        air.frame = CGRect(x: 0, y: 100, width: 1024, height: 297)
        waterTop.frame = CGRect(x: 0, y: air.frame.maxY, width: 740, height: 151)
        waterBottom.frame = CGRect(x: 0, y: waterTop.frame.maxY, width: 485, height: 150)
        landTop.frame = CGRect(x: waterTop.frame.maxX, y: air.frame.maxY, width: 284, height: 151)
        landBottom.frame = CGRect(x: waterBottom.frame.maxX, y: landTop.frame.maxY, width: 1024-waterBottom.frame.size.width, height: 150)
//        waterTop.backgroundColor = .red
//        waterBottom.backgroundColor = .red
//        air.backgroundColor = .green
//        landTop.backgroundColor = .blue
//        landBottom.backgroundColor = .blue
        vehicleView.addSubview(air)
        vehicleView.addSubview(waterTop)
        vehicleView.addSubview(waterBottom)
        vehicleView.addSubview(landTop)
        vehicleView.addSubview(landBottom)
    }
    func setUpBackground(){
        background.image = backgroundImage
        background.contentMode = UIView.ContentMode.scaleAspectFill
        background.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: 1024, height: 698)
        view.addSubview(background)
        background.isUserInteractionEnabled = true
    }
    func setUpVehicleView(){
        vehicleView.frame = CGRect(x: 0, y: 0, width: 1024, height: 100)
        vehicleView.backgroundColor = hexStringToUIColor(hex: "#ADD8E6")
        vehicleView.alpha = 0.8
        vehicleView.isUserInteractionEnabled = true
        background.addSubview(vehicleView)
        setUpVehicleViewContainer()
        //total number of spaces between the images will be numImages-1
        
    }
    func setUpVehicleViewContainer(){
        vehicleViewContainer = UIView()
        populateVehicles()
        var x = 0
        for i in 0..<vehicles.count{
            if( i != 0){
                x = Int(vehicles[i-1].frame.maxX + 10)
            }
            vehicles[i].frame = CGRect(x: x, y: 0, width: imageWidth, height: 98)
            vehicleViewContainer.addSubview(vehicles[i])
        }
        let totalImageWidth = imageWidth * numVehicles-1
        let totalImageSpacing = (numVehicles-1) * 10
        let width = totalImageWidth + totalImageSpacing
        vehicleViewContainer.frame = CGRect(x: 0, y: 0, width: width, height: 100)
        vehicleViewContainer.center = vehicleView.convert(vehicleView.center, from: vehicleView.superview)
        vehicleViewContainer.isUserInteractionEnabled = true
        vehicleView.addSubview(vehicleViewContainer)
        
    }
    func setUpTimerView(){
        //Left side of the screen
        let backgroundMaxY = background.frame.maxY
        let totalNavBarHeight = self.navigationController!.navigationBar.frame.maxY
        let timerHeight = 30
        let timerY = Int(backgroundMaxY - totalNavBarHeight) - timerHeight
        timer.frame = CGRect(x: 5 , y: timerY-5, width: 100, height: timerHeight)
        timer.contentMode = UIView.ContentMode.scaleAspectFill
        setUpTimerViewContainer()
        background.addSubview(timer)
        
    }
    func setUpTimerViewContainer(){
        timerContainer = [timer, minute, seconds0, seconds1]
        minute.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        minute.image = UIImage(named: "0.jpg")
        minute.restorationIdentifier = "0"
        colonLabel.text = ":"
        colonLabel.frame = CGRect(x: minute.frame.maxX, y: 0, width: 10, height: 25)
        seconds0.frame = CGRect(x: colonLabel.frame.maxX, y: 0, width: 20, height: 30)
        seconds1.frame = CGRect(x: seconds0.frame.maxX, y: 0, width: 20, height: 30)
        timerViewContainer.frame = CGRect(x: timer.frame.maxX + 2, y: timer.frame.minY, width: minute.frame.width + colonLabel.frame.width + seconds0.frame.width + seconds1.frame.width, height: 30)
        for i in 0..<timerContainer.count{
            timerContainer[i].contentMode = UIView.ContentMode.scaleAspectFit
            if i != 0 {
                timerViewContainer.addSubview(timerContainer[i])
            }
        }
        timerViewContainer.backgroundColor = hexStringToUIColor(hex: "#C4ECFF")
        timerViewContainer.addSubview(colonLabel)
        colonLabel.font = colonLabel.font.withSize(30)
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
        scoreViewContainer.frame = CGRect(x: background.frame.maxX - 150, y: timer.frame.minY, width: 60, height: 30)
        scoreViewContainer.backgroundColor = .clear
        for i in 0..<scoreContainer.count{
            scoreContainer[i].contentMode = UIView.ContentMode.scaleAspectFit
            scoreViewContainer.addSubview(scoreContainer[i])
        }
        score.frame = CGRect(x: scoreViewContainer.frame.minX-100, y: timer.frame.minY, width: 100, height: 30)
        background.addSubview(score)
        background.addSubview(scoreViewContainer)
    }
    func populateVehicles(){
        while vehicles.count != numVehicles{
            let vehicle = imagePool[Int.random(in: 0...14)]
            //vehicle.contentMode = UIView.ContentMode.scaleAspectFit
            if !vehicles.contains(where: {$0.image == vehicle.image}){
                vehicle.contentMode = UIView.ContentMode.scaleAspectFit
                vehicle.isUserInteractionEnabled = true
                panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
                vehicle.addGestureRecognizer(panGR)
                vehicles.append(vehicle)
            }
        }
        
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer){
        let vehicle = sender.view as! CustomUIImageView
        startGameTimer()
        switch sender.state{
        case .began:
            vehicleOrigin = vehicle.frame.origin
            vehicleViewContainer.bringSubviewToFront(vehicle)
        case .changed:
            moveWithPanGR(vehicle: vehicle, sender: sender)
        case .ended:
            verifyPlacement(with: vehicle, sender: sender)
            let endGame = (vehicles.count == 0) ? { [self] in
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
            } : {}
            endGame()
        default:
            break
        }
    }
    func saveData(){
        var highscores = Score.getData()
        highscores.append(Score(name: "Sorting", score: self.currentScore, difficulty: self.difficulty))
        Score.saveData(data: highscores)
    }
    func moveWithPanGR(vehicle:CustomUIImageView, sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: vehicle)
        vehicle.center = CGPoint(x: vehicle.center.x + translation.x , y: vehicle.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: vehicleViewContainer)
    }
    func addVehicleToContainer(_ vehicle: CustomUIImageView){
        let pathToSound = Bundle.main.path(forResource: "correct", ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        }catch{}
        isCorrect = true
        getScore()
        pointsAnimation(vehicle: vehicle)
        vehicles.remove(at: vehicles.firstIndex(of: vehicle)!)
        isFirstFound = (vehicles.count == numVehicles-1) ? true : false
        if(isFirstFound){
            startScoreTimer()
        }
        
    }
    func pointsAnimation(vehicle: CustomUIImageView){
       let pointsLabel = UILabel()
        pointsLabel.text = "+\(pointsToBeAdded)"
//        print(secondClicked.frame.minY)
        pointsLabel.frame = CGRect(x: 0, y: -50, width: 50, height: 50)
        pointsLabel.center.x = vehicle.frame.width/2
        pointsLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        
        pointsLabel.sizeToFit()
        vehicle.addSubview(pointsLabel)
        UILabel.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            pointsLabel.layer.position.y = pointsLabel.frame.minY - 5
        }, completion: { _ in
            pointsLabel.isHidden = true
            pointsLabel.removeFromSuperview()
        })
    }
    
    func verifyPlacement(with vehicle: CustomUIImageView, sender: UIPanGestureRecognizer){
        let shouldVehicleBeInWater = (vehicle.frame.intersects(waterTop.frame) &&
                                      vehicle.frame.minX < waterTop.frame.maxX - 30
                                      && vehicle.frame.minY > air.frame.maxY - 30 && vehicle.frame.minY < landBottom.frame.minY - 30
                                         ||
                                (vehicle.frame.intersects(waterBottom.frame) &&
                                vehicle.frame.minX < waterBottom.frame.maxX - 30
                                ))
                                && vehicle.category == .water

        let shouldVehicleBeInAir = vehicle.frame.intersects(air.frame) &&
                                    vehicle.category == .air &&
        vehicle.frame.minY < waterTop.frame.minY - 40
        let shouldVehicleBeOnLand = ((vehicle.frame.intersects(landTop.frame) &&
                                      vehicle.frame.minY > air.frame.maxY - 30 ) ||
                                     (vehicle.frame.intersects(landBottom.frame) &&
                                      vehicle.frame.minY > waterTop.frame.maxY - 30) ) &&
                                      vehicle.category == .land
        if(shouldVehicleBeInAir || shouldVehicleBeOnLand || shouldVehicleBeInWater){
            addVehicleToContainer(vehicle)
        }else{
            returnVehicleToOrigin(vehicle: vehicle)
        }
    }
    
    func returnVehicleToOrigin(vehicle: CustomUIImageView){
        CustomUIImageView.animate(withDuration: 2.5, animations: {
            vehicle.frame.origin = self.vehicleOrigin
        })
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
            //            minute.image = UIImage(named: "0.jpg")
            //            minute.restorationIdentifier = "0"
            //            seconds0.image = UIImage(named: "0.jpg")
            //            seconds0.restorationIdentifier = "0"
            //            seconds1.image = UIImage(named: "1.jpg")
            //            seconds1.restorationIdentifier = "1"
            timeRemaining = 60
            numVehicles = 8
            imageWidth = 100
            
        case 1:
            seconds0.image = UIImage(named: "4.jpg")
            seconds0.restorationIdentifier = "4"
            seconds1.image = UIImage(named: "5.jpg")
            seconds1.restorationIdentifier = "5"
            timeRemaining = 45
            numVehicles = 10
            imageWidth = 90
        case 2:
            seconds0.image = UIImage(named: "3.jpg")
            seconds0.restorationIdentifier = "3"
            seconds1.image = UIImage(named: "0.jpg")
            seconds1.restorationIdentifier = "0"
            timeRemaining = 30
            numVehicles = 12
            imageWidth = 75
        default:
            break
        }
    }
    func startGameTimer(){
        if(!hasTimerStarted){
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            hasTimerStarted = true
        }
    }
    func startScoreTimer(){
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownScoreTimer), userInfo: nil, repeats: true)
    }
    func getScore(){
        if(isCorrect){
            switch(scoreTimerCounter){
            case 1,2:
                //print("added 5")
                pointsToBeAdded = 5
            case 3,4:
               // print("added 4")
                pointsToBeAdded = 4
            default:
               // print("added 3")
                pointsToBeAdded = 3
                
            }
            currentScore += pointsToBeAdded
            isCorrect = false
            scoreTimerCounter = 1
           // print("current score \(currentScore)")
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
    @objc func countDownScoreTimer(){
       // print("timer: \(scoreTimerCounter!)")
        scoreTimerCounter+=1
    }
    @objc func countDown(){
        
        if timeRemaining > 0{
            timeRemaining -= 1
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
    override func viewDidDisappear(_ animated: Bool) {
        if(scoreTimer != nil){
            scoreTimer.invalidate()
        }
        if (gameTimer != nil){
            gameTimer.invalidate()
        }
    }
}
enum Categories{
    case water
    case air
    case land
}
class CustomUIImageView: UIImageView{
    
    var category:Categories
    init(_ category: Categories, _ imageName: String){
        self.category = category
        super.init(image: UIImage(named: imageName))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

