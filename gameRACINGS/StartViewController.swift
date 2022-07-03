import UIKit
import AVFoundation
import CoreMotion

class StartViewController: UIViewController {
    
    //MARK: - outlets
    @IBOutlet private weak var leftEdgeImgeView: UIImageView!
    @IBOutlet private weak var rightEdgeImageView: UIImageView!
    @IBOutlet private weak var roadImageView: UIImageView!
    @IBOutlet private weak var carImageView: UIImageView!
    @IBOutlet private  var roadView: UIView!
    @IBOutlet private  var rightEdgeView: UIView!
    @IBOutlet private weak var leftEdgeView: UIView!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var gameOverLabel: UILabel!
    
    //MARK: - let
    private let motionManager = CMMotionManager()
    let arrayEdgeObstacle: [UIImage?] = [UIImage(named: "tree"),UIImage(named: "pond"), UIImage(named: "house"), UIImage(named: "tree2"), UIImage(named: "tree3"), UIImage(named: "house2")]
    
    //MARK: - var
    var index = 0
    var data = ""
    var gameOver = false
    var settingsGame = Setting(name: "Username", car: "car", obstacle: "obstacle", speed: 5, timeInterval: 0.5, timeIntervalMarkup: 0.3, complication: "easy")
    var arrayRecords: [Records] = []
    var player: AVAudioPlayer?
    var step: CGFloat = 40
    var jumpHeight: CGFloat = 20
    var checkCollision = true
    
    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSettings()
        self.playSoundCar()
        self.startAcceleromater()
        self.tapRecognizerJump()
        Manager.shared.playSoundSiren()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgeImage()
        self.roadImage()
        self.carImage()
        self.nameDriver()
        self.animateCarPolice()
        self.fontLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timerMarkup()
        self.timerEdgeObsracle()
        self.timerObstacle()
        self.starTimerIntersects()
    }
    
    //MARK: - IBActions
    @IBAction func tapRecognizer(_ sender: UITapGestureRecognizer) {
        self.jumpCar()
    }
    
    //MARK: - flow funcs
    
    func loadSettings () {
        if let settings = UserDefaults.standard.value(Setting.self, forKey: "settings"){
            self.settingsGame = settings
        }
    }
    
    func records () {
        guard let name = self.nameLabel.text else {
            return
        }
        if let arrayRecords = UserDefaults.standard.value([Records].self, forKey: "arrayRecords") {
            self.arrayRecords = arrayRecords
        }
        let data = self.dataFormat()
        
        let records = Records(name: name, record: String(self.index), speed: self.settingsGame.complication, date: data)
        self.arrayRecords.append(records)
    }
    
    func saveRecords() {
        UserDefaults.standard.set(encodable: arrayRecords, forKey: "arrayRecords")
    }
}

//MARK: - extension
private extension StartViewController {
    
    func leftStopCar () -> Bool {
        return self.carImageView.frame.origin.x > 0
    }
    
    func rightStopCar () -> Bool {
        return self.carImageView.frame.origin.x < self.roadView.frame.size.width - self.carImageView.frame.size.width
    }
    
    func startAcceleromater() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main)
            { [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    self?.moveCar(delta: CGFloat(acceleration.x))
                }
            }
        }
    }
    
    func moveCar(delta: CGFloat) {
        if self.gameOver {
            return
        }
        if self.leftStopCar(), self.rightStopCar() {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
                self.carImageView.frame.origin.x += self.step * delta
            }
        } else {
            self.stopGame()
            Manager.shared.playSoundDrift()
        }
    }
    
    func tapRecognizerJump() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(_:)))
        recognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(recognizer)
    }
    
    func jumpCar() {
        if self.gameOver {
            return
        }
        self.carUp()
    }
    
    func carUp() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut) {
            self.checkCollision = false
            self.carImageView.layer.frame.size.width += self.jumpHeight
            self.carImageView.layer.frame.size.height += self.jumpHeight
        } completion: { (_) in
            self.carDown()
        }
    }
    
    func carDown() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut) {
            self.carImageView.layer.frame.size.width -= self.jumpHeight
            self.carImageView.layer.frame.size.height -= self.jumpHeight
        } completion: { (_) in
            self.checkCollision = true
        }
    }
    
    func edgeImage () {
        let image = UIImage(named: "edge")
        self.leftEdgeImgeView.contentMode = .scaleAspectFill
        self.rightEdgeImageView.contentMode = .scaleAspectFill
        self.leftEdgeImgeView.image = image
        self.rightEdgeImageView.image = image
    }
    
    func roadImage () {
        let image = UIImage(named: "road")
        self.roadImageView.contentMode = .scaleAspectFill
        self.roadImageView.image = image
    }
    
    func leftEdgeObstakleImageView () -> UIImageView {
        let image = self.arrayEdgeObstacle.randomElement()
        let edgeImageView = UIImageView ()
        edgeImageView.frame = CGRect(x: self.leftEdgeImgeView.frame.origin.x, y: -self.leftEdgeImgeView.frame.size.width , width: self.leftEdgeImgeView.frame.size.width, height: self.leftEdgeImgeView.frame.size.width / 2)
        edgeImageView.contentMode = .scaleAspectFill
        edgeImageView.image = image as? UIImage
        self.leftEdgeView.addSubview(edgeImageView)
        return edgeImageView
    }
    
    func rightEdgeObstakleImageView () -> UIImageView {
        let image = self.arrayEdgeObstacle.randomElement()
        let edgeImageView = UIImageView ()
        edgeImageView.frame = CGRect(x: self.rightEdgeImageView.frame.origin.x, y: -self.rightEdgeImageView.frame.size.width, width: self.rightEdgeImageView.frame.size.width, height: self.rightEdgeImageView.frame.size.width / 2)
        edgeImageView.contentMode = .scaleAspectFill
        edgeImageView.image = image as? UIImage
        self.rightEdgeView.addSubview(edgeImageView)
        return edgeImageView
    }
    
    func animateEdgeObstacleView () {
        let leftEdgeObstakleImageView = self.leftEdgeObstakleImageView()
        let rightEdgeObstakleImageView = self.rightEdgeObstakleImageView()
        UIView.animate(withDuration: TimeInterval(self.settingsGame.speed), delay: 0, options: .curveLinear) {
            leftEdgeObstakleImageView.frame.origin.y += self.leftEdgeView.frame.size.height + self.leftEdgeImgeView.frame.size.width
            rightEdgeObstakleImageView.frame.origin.y += self.rightEdgeView.frame.size.height + self.rightEdgeImageView.frame.size.width
        } completion: { (_) in
            leftEdgeObstakleImageView.removeFromSuperview()
            rightEdgeObstakleImageView.removeFromSuperview()
        }
    }
    
    func timerEdgeObsracle () {
        let timer = Timer.scheduledTimer(withTimeInterval: 2.6 - self.settingsGame.timeInterval, repeats: true) { (_) in
            if self.gameOver {
                return
            }
            self.animateEdgeObstacleView()
        }
    }
    
    func markupView () -> UIView {
        let markupView = UIView()
        markupView.frame = CGRect(x: self.roadView.frame.size.width / 2 - 10, y: -60, width: 20, height: 60)
        markupView.backgroundColor = .white
        self.roadImageView.addSubview(markupView)
        return markupView
    }
    
    func animateMarkupView () {
        let markupView = self.markupView()
        UIView.animate(withDuration: TimeInterval(self.settingsGame.speed), delay: 0, options: .curveLinear) {
            markupView.frame.origin.y += self.roadImageView.frame.size.height + markupView.frame.size.height
        } completion: { (_) in
            markupView.removeFromSuperview()
        }
    }
    
    func timerMarkup () {
        let timer = Timer.scheduledTimer(withTimeInterval: 1 - self.settingsGame.timeIntervalMarkup, repeats: true) { (_) in
            if self.gameOver {
                return
            }
            self.animateMarkupView()
        }
    }
    
    func obstakleImageView () -> UIImageView {
        let obstakleImageView = UIImageView ()
        let image = UIImage(named: self.settingsGame.obstacle)
        obstakleImageView.tag = 1
        obstakleImageView.frame = CGRect(x: .random(in: self.roadImageView.frame.origin.x...self.roadImageView.frame.size.width - 50), y: 0, width: 50, height: 50)
        obstakleImageView.contentMode = .scaleAspectFit
        obstakleImageView.image = image
        self.roadImageView.addSubview(obstakleImageView)
        return obstakleImageView
    }
    
    func animateObstacleView () {
        let obstakleImageView = self.obstakleImageView()
        self.index += 10
        self.resultLabel.text = String(self.index)
        UIView.animate(withDuration: TimeInterval(self.settingsGame.speed), delay: 0, options: .curveLinear) {
            obstakleImageView.frame.origin.y += self.roadImageView.frame.size.height + obstakleImageView.frame.size.height
        } completion: { (_) in
            obstakleImageView.removeFromSuperview()
        }
    }
    
    func timerObstacle () {
        let timer = Timer.scheduledTimer(withTimeInterval: 3 - self.settingsGame.timeInterval, repeats: true) { (timer) in
            if self.gameOver {
                return
            }
            self.animateObstacleView()
        }
    }
    
    func centreMarkup () -> UIView {
        let markupView = UIView()
        markupView.frame = CGRect(x: self.roadView.frame.size.width / 2 - 10, y: 0, width: 20, height: self.roadView.frame.size.height)
        markupView.backgroundColor = .white
        self.roadImageView.addSubview(markupView)
        return markupView
    }
    
    func leftCarPoliceImageView () -> (UIImageView, UIImageView, UIImageView) {
        let image = UIImage(named: "carpoliceleft")
        let oneCar = UIImageView()
        let twoCar = UIImageView()
        let threeCar = UIImageView()
        oneCar.frame = CGRect(x: self.leftEdgeView.frame.origin.x, y: self.leftEdgeView.frame.size.height / 8, width: self.leftEdgeView.frame.size.width, height: 70)
        twoCar.frame = CGRect(x: self.leftEdgeView.frame.origin.x, y: self.leftEdgeView.frame.size.height / 2, width: self.leftEdgeView.frame.size.width, height: 70)
        threeCar.frame = CGRect(x: self.leftEdgeView.frame.origin.x, y: self.leftEdgeView.frame.size.height - self.leftEdgeView.frame.size.width, width: self.leftEdgeView.frame.size.width, height: 70)
        oneCar.contentMode = .scaleAspectFill
        twoCar.contentMode = .scaleAspectFill
        threeCar.contentMode = .scaleAspectFill
        oneCar.image = image
        twoCar.image = image
        threeCar.image = image
        self.leftEdgeView.addSubview(oneCar)
        self.leftEdgeView.addSubview(twoCar)
        self.leftEdgeView.addSubview(threeCar)
        return (oneCar, twoCar, threeCar)
    }
    
    func rightCarPoliceImageView () -> (UIImageView, UIImageView, UIImageView) {
        let image = UIImage(named: "carpoliceright")
        let oneCar = UIImageView()
        let twoCar = UIImageView()
        let threeCar = UIImageView()
        oneCar.frame = CGRect(x: self.rightEdgeImageView.frame.origin.x, y: self.rightEdgeImageView.frame.size.height / 8, width: self.rightEdgeImageView.frame.size.width, height: 70)
        twoCar.frame = CGRect(x: self.rightEdgeImageView.frame.origin.x, y: self.rightEdgeImageView.frame.size.height / 2, width: self.rightEdgeImageView.frame.size.width, height: 70)
        threeCar.frame = CGRect(x: self.rightEdgeImageView.frame.origin.x, y: self.rightEdgeImageView.frame.size.height - self.rightEdgeImageView.frame.size.width, width: self.rightEdgeImageView.frame.size.width, height: 70)
        oneCar.contentMode = .scaleAspectFill
        twoCar.contentMode = .scaleAspectFill
        threeCar.contentMode = .scaleAspectFill
        oneCar.image = image
        twoCar.image = image
        threeCar.image = image
        self.rightEdgeView.addSubview(oneCar)
        self.rightEdgeView.addSubview(twoCar)
        self.rightEdgeView.addSubview(threeCar)
        return (oneCar, twoCar, threeCar)
    }
    
    func animateCarPolice () {
        let centreView = self.centreMarkup()
        let leftCarImageView = self.leftCarPoliceImageView()
        let rightCarImageView = self.rightCarPoliceImageView()
        UIView.animate(withDuration: TimeInterval(self.settingsGame.speed), delay: 0, options: .curveLinear) {
            centreView.frame.origin.y += self.roadView.frame.size.height
            leftCarImageView.0.frame.origin.y += self.leftEdgeView.frame.size.height
            leftCarImageView.1.frame.origin.y += self.leftEdgeView.frame.size.height
            leftCarImageView.2.frame.origin.y += self.leftEdgeView.frame.size.height
            rightCarImageView.0.frame.origin.y += self.rightEdgeView.frame.size.height
            rightCarImageView.1.frame.origin.y += self.rightEdgeView.frame.size.height
            rightCarImageView.2.frame.origin.y += self.rightEdgeView.frame.size.height
        } completion: { (_) in
            centreView.removeFromSuperview()
            leftCarImageView.0.removeFromSuperview()
            leftCarImageView.1.removeFromSuperview()
            leftCarImageView.2.removeFromSuperview()
            rightCarImageView.0.removeFromSuperview()
            rightCarImageView.1.removeFromSuperview()
            rightCarImageView.2.removeFromSuperview()
        }
    }
    
    func inter () -> Bool {
        if !self.checkCollision {
            return false
        }
        
        let array = self.roadImageView.subviews
            .filter({
                if let currentPosition = $0.layer.presentation() {
                    return $0.tag == 1 && currentPosition.frame.intersects(self.carImageView.frame)
                }
                return false
            })
        return array.count > 0
    }
    
    func starTimerIntersects () {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            if self.gameOver {
                return
            }
            if self.inter() {
                timer.invalidate()
                Manager.shared.playSoundCrash()
                let image = UIImage(named: "boom")
                self.carImageView.image = image
                self.stopGame()
                return
            }
        }
    }
    
    func stopGame () {
        self.gameOverLabel.isHidden = false
        self.records()
        self.gameOver = true
        self.nukeAllAnimation()
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            self.saveRecords()
            self.navigationController?.popViewController(animated: true)
        }
        self.player?.stop()
    }
    
    func nukeAllAnimation () {
        self.roadImageView.subviews.forEach({$0.layer.removeAllAnimations()})
        self.roadImageView.layer.removeAllAnimations()
        self.roadImageView.layoutIfNeeded()
        self.leftEdgeView.subviews.forEach({$0.layer.removeAllAnimations()})
        self.leftEdgeView.layer.removeAllAnimations()
        self.leftEdgeView.layoutIfNeeded()
        self.rightEdgeView.subviews.forEach({$0.layer.removeAllAnimations()})
        self.rightEdgeView.layer.removeAllAnimations()
        self.rightEdgeView.layoutIfNeeded()
    }
    
    func carImage() {
        let image = UIImage(named: self.settingsGame.car)
        self.carImageView.image = image
    }
    
    func nameDriver() {
        self.nameLabel.text = settingsGame.name
    }
    
    func dataFormat() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy / HH:mm"
        let cureentDate = formatter.string(from: date)
        return cureentDate
    }
    
    func playSoundCar () {
        
        guard let url = Bundle.main.url(forResource: "Car", withExtension: "mp3") else {return}
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            if let player = player {
                
                player.numberOfLoops = -1
                player.prepareToPlay()
                player.play()
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fontLabel() {
        self.gameOverLabel.font(40)
        self.nameLabel.font(19)
        self.resultLabel.font(30)
    }
}
