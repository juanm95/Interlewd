//
//  SentViewController.swift
//  FiftyFifty
//
//  Created by Caroline Amy Debs on 5/3/17.
//  Copyright © 2017 Caroline Amy Debs. All rights reserved.
//
import AVFoundation
import UIKit

class SentViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func buttonPushed(_ sender: Any) {
        player?.stop();
        let refreshAlert = UIAlertView()
        refreshAlert.title = "Message Sent"
        refreshAlert.message = "Chicken Attack was Sent to Brad"
        refreshAlert.addButton(withTitle: "OK")
        //refreshAlert.addButton(withTitle: "😂")
        //refreshAlert.addButton(withTitle: "💩")
        //refreshAlert.addButton(withTitle: "😡")
        //refreshAlert.addButton(withTitle: "😎")
        refreshAlert.show()
    }
    
    @IBOutlet weak var ChickenAttack: UIButton!
    
    @IBAction func PlaySong(_ sender: Any) {
        playSound(songName: "ChickenAttack")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var player: AVAudioPlayer?
    
    func playSound(songName:String) {
        guard let sound = NSDataAsset(name: songName) else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            player!.play()
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    
}
