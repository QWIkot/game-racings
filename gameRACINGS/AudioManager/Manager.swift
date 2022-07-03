import Foundation
import AVFoundation

class Manager {
    
    static let shared = Manager ()
    var player: AVAudioPlayer?
    
    private init () {}
    
    func playSoundClick () {
        
        guard let url = Bundle.main.url(forResource: "click", withExtension: "mp3") else {return}
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            if let player = player {
                
                player.prepareToPlay()
                player.play()
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSoundSiren () {
        
        guard let url = Bundle.main.url(forResource: "Siren", withExtension: "mp3") else {return}
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            if let player = player {
                
                player.prepareToPlay()
                player.play()
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSoundCrash () {
        
        guard let url = Bundle.main.url(forResource: "Crash", withExtension: "mp3") else {return}
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            if let player = player {
                
                player.prepareToPlay()
                player.play()
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSoundDrift () {
        
        guard let url = Bundle.main.url(forResource: "Drift", withExtension: "mp3") else {return}
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            if let player = player {
                
                player.prepareToPlay()
                player.play()
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
}
