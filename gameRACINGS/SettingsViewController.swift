import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - outlets
    @IBOutlet private weak var carImageView: UIImageView!
    @IBOutlet private weak var obstacleImageView: UIImageView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var carLabel: UILabel!
    @IBOutlet private weak var obstacleLabel: UILabel!
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var backButtonPressed: UIButton!
    @IBOutlet private weak var saveButtonPressed: UIButton!
    @IBOutlet private weak var ImageView: UIImageView!
    
    //MARK: - let
    let arrayCarImage: [String] = ["car", "carred", "caryellow", "carblue"]
    let arrayObstacleImage: [String] = ["obstacle", "barrel", "pig"]
    let arraySpeed: [(Int, Double, Double, String)] = [(5, 0.5, 0.3, "easy"), (3, 1.2, 0.6, "normal"), (2, 1.7, 0.7, "hard")]
    
    //MARK: - var
    var indexCar = 0
    var indexObstacle = 0
    var indexSpeed: (Int, Double, Double, String) = (0, 0.0, 0.0, "")
    var settingsGame: Setting?
    
    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultSettings()
        self.recognizer()
        self.fontLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.carImage()
        self.obstacleImage()
        self.backgrondImage()
    }
    
    //MARK: IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        Manager.shared.playSoundClick()
    }
    
    @IBAction func nexCarImage(_ sender: UIButton) {
        self.nextIndexCarImage()
    }
    
    @IBAction func backCarImage(_ sender: UIButton) {
        self.backIndexCarImage()
    }
    
    @IBAction func nexObstacleImage(_ sender: UIButton) {
        self.nextIndexObstacleImage()
    }
    
    @IBAction func backObstacleImage(_ sender: UIButton) {
        self.backIndexObstacleImage()
    }
    
    @IBAction func saveSettingsButtonPressed(_ sender: UIButton) {
        self.saveSettings()
    }
    
    @IBAction func tapRecognizer(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //MARK: - flow funcs
    
    func saveSettings() {
        if let textName = self.textField.text {
            let settings = Setting(name: textName, car: self.arrayCarImage[self.indexCar], obstacle: self.arrayObstacleImage[self.indexObstacle], speed: self.indexSpeed.0, timeInterval: self.indexSpeed.1, timeIntervalMarkup: self.indexSpeed.2, complication: self.indexSpeed.3)
            UserDefaults.standard.set(encodable: settings, forKey: "settings")
        }
        self.navigationController?.popViewController(animated: true)
        Manager.shared.playSoundClick()
    }
}

//MARK: - extension
extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arraySpeed.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(arraySpeed[row].3)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let speed = self.arraySpeed[row]
        return self.indexSpeed = speed
    }
}

private extension SettingsViewController {
    func recognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(_:)))
        self.view.addGestureRecognizer(recognizer)
    }
    
    func backgrondImage () {
        let image = UIImage(named: "backgraund")
        self.ImageView.image = image
    }
    
    func carImage () {
        let image = UIImage(named: arrayCarImage[indexCar])
        self.carImageView.image = image
    }
    
    func obstacleImage () {
        let image = UIImage(named: arrayObstacleImage[indexObstacle])
        self.obstacleImageView.image = image
    }
    
    func nextIndexCarImage() {
        if indexCar < self.arrayCarImage.endIndex - 1 {
            indexCar += 1
            self.carImage()
            Manager.shared.playSoundClick()
        } else if indexCar == self.arrayCarImage.endIndex - 1 {
            indexCar = self.arrayCarImage.startIndex
            self.carImage()
            Manager.shared.playSoundClick()
        }
    }
    
    func backIndexCarImage() {
        if indexCar > 0 {
            indexCar -= 1
            self.carImage()
            Manager.shared.playSoundClick()
        } else if indexCar == 0 {
            indexCar = self.arrayCarImage.count - 1
            self.carImage()
            Manager.shared.playSoundClick()
        }
    }
    
    func nextIndexObstacleImage() {
        if indexObstacle < self.arrayObstacleImage.endIndex - 1 {
            indexObstacle += 1
            self.obstacleImage()
            Manager.shared.playSoundClick()
        } else if indexObstacle == self.arrayObstacleImage.endIndex - 1 {
            indexObstacle = self.arrayObstacleImage.startIndex
            self.obstacleImage()
            Manager.shared.playSoundClick()
        }
    }
    
    func backIndexObstacleImage() {
        if indexObstacle > 0 {
            indexObstacle -= 1
            self.obstacleImage()
            Manager.shared.playSoundClick()
        } else if indexObstacle == 0 {
            indexObstacle = self.arrayObstacleImage.count - 1
            self.obstacleImage()
            Manager.shared.playSoundClick()
        }
    }
    
    func defaultSettings () {
        self.indexCar = self.arrayCarImage.startIndex
        self.indexObstacle = self.arrayObstacleImage.startIndex
        self.indexSpeed.0 = self.arraySpeed[0].0
        self.indexSpeed.1 = self.arraySpeed[0].1
        self.indexSpeed.2 = self.arraySpeed[0].2
        self.indexSpeed.3 = self.arraySpeed[0].3
    }
    
    func fontLabel() {
        self.nameLabel.font(17)
        self.carLabel.font(17)
        self.obstacleLabel.font(17)
        self.speedLabel.font(17)
        self.backButtonPressed.titleLabel?.font(backButtonPressed, 30)
        self.saveButtonPressed.titleLabel?.font(saveButtonPressed, 20)
    }
    
}
