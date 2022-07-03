import UIKit

class RecordsViewController: UIViewController {
    
    //MARK: - outlets
    @IBOutlet private weak var recordsLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backButtonPressed: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - var
    var arrayRecords: [Records] = []
    
    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButtonPressed.titleLabel?.font(backButtonPressed, 30)
        self.recordsLabel.font(50)
        self.backgroundRecords()
    }
    
    //MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.saveRecords()
        self.navigationController?.popViewController(animated: true)
        Manager.shared.playSoundClick()
    }
    
    //MARK: - flow funcs
  private  func backgroundRecords () {
        let image = UIImage(named: "backgraund")
        self.imageView.image = image
    }
    
    func loadRecords() {
        if let records = UserDefaults.standard.value([Records].self, forKey: "arrayRecords") {
            self.arrayRecords = records
        }
    }
    
    func saveRecords() {
        let arrayRecords = self.arrayRecords
        UserDefaults.standard.set(encodable: arrayRecords, forKey: "arrayRecords")
    }
}

//MARK: - extension
extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(name: self.arrayRecords[indexPath.row].name, record: self.arrayRecords[indexPath.row].record, speed: self.arrayRecords[indexPath.row].speed, date: self.arrayRecords[indexPath.row].date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayRecords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
