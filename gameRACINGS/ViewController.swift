import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //MARK: - outlets
    @IBOutlet private weak var starView: UIView!
    @IBOutlet private weak var settingsView: UIView!
    @IBOutlet private weak var recordsView: UIView!
    @IBOutlet private weak var menuImageView: UIImageView!
    @IBOutlet private weak var menuLabel: UILabel!
    @IBOutlet private weak var starButtonPressed: UIButton!
    @IBOutlet private weak var settingsButtomPressed: UIButton!
    @IBOutlet private weak var recordsButtonPressed: UIButton!
    
    //MARK: - var
    var player: AVAudioPlayer?
    
    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playSoundIntro()
        self.menuImageView.addParalaxEffect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.starView.radius()
//        self.settingsView.radius()
//        self.recordsView.radius()
        self.menuImage()
        self.myString()
        self.fontLabel()
    }
    
    //MARK: - IBActions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        self.navigationStartViewController()
        Manager.shared.playSoundClick()
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        self.navigationSettingsViewController()
        Manager.shared.playSoundClick()
    }
    
    @IBAction func recordsButtonPressed(_ sender: UIButton) {
        self.navigationRecordsViewController()
        Manager.shared.playSoundClick()
    }
    
    //MARK: - flow funcs
    
    func navigationStartViewController() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func navigationSettingsViewController() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func navigationRecordsViewController() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecordsViewController") as? RecordsViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func menuImage () {
        let image = UIImage (named: "menu")
        self.menuImageView.image = image
    }
    
    private func myString() {
        let myString = "NFS 10"
        let myShadow = NSShadow ()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize (width: 5, height: 5)
        myShadow.shadowColor = UIColor.white
        let myAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.shadow: myShadow]
        let myAttrString = NSMutableAttributedString(string: myString, attributes: myAttribute)
        self.menuLabel.attributedText = myAttrString
    }
    
    private func playSoundIntro () {
        guard let url = Bundle.main.url(forResource: "Intro", withExtension: "mp3") else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            if let player = player {
                player.volume = 0.2
                player.numberOfLoops = -1
                player.prepareToPlay()
                player.play()
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func fontLabel() {
        self.menuLabel.font(80)
        self.starButtonPressed.titleLabel?.font(starButtonPressed, 30)
        self.settingsButtomPressed.titleLabel?.font(settingsButtomPressed, 30)
        self.recordsButtonPressed.titleLabel?.font(recordsButtonPressed, 30)
    }
}

//MARK: - extension
extension UIView {
    
    func radius (_ radius: Int = 20) {
        self.layer.cornerRadius = CGFloat(radius)
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 20
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
    
    func addParalaxEffect(amount: Int = 40) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }
}

extension UILabel {
    
    func font( _ size: CGFloat) {
        let font = UIFont(name: "Facon-BoldItalic", size: size)
        self.font = font
    }
    
    func font(_ button: UIButton, _ size: CGFloat) {
        let font = UIFont(name: "Facon-BoldItalic", size: size)
        button.titleLabel?.font = font
    }
}

