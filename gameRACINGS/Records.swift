import Foundation

class Records: Codable {
    
    var name: String
    var record: String
    var speed: String
    var date: String
    
    init(name: String, record: String, speed: String, date: String) {
        self.name = name
        self.record = record
        self.speed = speed
        self.date = date
    }
    public enum CodingKeys: String, CodingKey {
            case name, record, speed, date
        }
        
        required public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.name = try container.decode(String.self, forKey: .name)
            self.record = try container.decode(String.self, forKey: .record)
            self.speed = try container.decode(String.self, forKey: .speed)
            self.date = try container.decode(String.self, forKey: .date)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.name, forKey: .name)
            try container.encode(self.record, forKey: .record)
            try container.encode(self.speed, forKey: .speed)
            try container.encode(self.date, forKey: .date)
        }
        
    }
