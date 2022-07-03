import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.font(15)
        self.recordLabel.font(15)
        self.speedLabel.font(15)
        self.dateLabel.font(15)
     
    }
    
    func configure (name: String, record: String, speed: String, date: String) {
        self.nameLabel.text = "Name: \(name)"
        self.recordLabel.text = "Record: \(record)"
        self.speedLabel.text = "Speed: \(speed)"
        self.dateLabel.text = "Date: \(date)"
       }
}
