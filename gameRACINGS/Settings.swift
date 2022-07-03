import Foundation

class Setting: Codable {
    
    var name: String
    var car: String
    var obstacle: String
    var speed: Int
    var timeInterval: Double
    var timeIntervalMarkup: Double
    var complication: String
    
    init(name: String, car: String, obstacle: String, speed: Int, timeInterval: Double, timeIntervalMarkup: Double, complication: String) {
        self.name = name
        self.car = car
        self.obstacle = obstacle
        self.speed = speed
        self.timeInterval = timeInterval
        self.timeIntervalMarkup = timeIntervalMarkup
        self.complication = complication
    }
    
    public enum CodingKeys: String, CodingKey {
        case name, car, obstacle, speed, timeInterval, timeIntervalMarkup, complication
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.car = try container.decode(String.self, forKey: .car)
        self.obstacle = try container.decode(String.self, forKey: .obstacle)
        self.speed = try container.decode(Int.self, forKey: .speed)
        self.timeInterval = try container.decode(Double.self, forKey: .timeInterval)
        self.timeIntervalMarkup = try container.decode(Double.self, forKey: .timeIntervalMarkup)
        self.complication = try container.decode(String.self, forKey: .complication)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.car, forKey: .car)
        try container.encode(self.obstacle, forKey: .obstacle)
        try container.encode(self.speed, forKey: .speed)
        try container.encode(self.timeInterval, forKey: .timeInterval)
        try container.encode(self.timeIntervalMarkup, forKey: .timeIntervalMarkup)
        try container.encode(self.complication, forKey: .complication)
    }
    
}


