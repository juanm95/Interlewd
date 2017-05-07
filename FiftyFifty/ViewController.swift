//
//  ViewController.swift
//  FiftyFifty
//
//  Created by Caroline Amy Debs on 5/3/17.
//  Copyright © 2017 Caroline Amy Debs. All rights reserved.
//
import AVFoundation
import UIKit
//Kek
class ViewController: UIViewController {
    
    var songPlaying = ""

    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var pause: UIButton!
    
    @IBAction func play1(_ sender: Any) {
        songPlaying = "Tunnel Vision"
        playSound(songName: "TunnelVision")
    }
    @IBAction func play2(_ sender: Any) {
        songPlaying = "Congratulations"
        playSound(songName: "Congratulations")
    }
    @IBAction func play3(_ sender: Any) {
        songPlaying = "Drowning"
        playSound(songName: "Drowning")
    }
    @IBAction func pauseSong(_ sender: Any) {
        stopPlayer()
        play.isHidden = false
        pause.isHidden = true
    }

    @IBAction func contSong(_ sender: Any) {
        player?.play()
        pause.isHidden = false
        play.isHidden = true
    }

    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = false
        play.isHidden = true
        nowPlaying.text = ""
    }
    @IBOutlet weak var nowPlaying: UILabel!
    
    @IBAction func gotMail(_ sender: Any) {
        let when = DispatchTime.now() + 7
        songPlaying = "Friday"
        DispatchQueue.main.asyncAfter(deadline: when) {
            let refreshAlert = UIAlertView()
            refreshAlert.title = "You Got REKT"
            refreshAlert.message = "Brad Sent You 'Friday' by Rebecca Black"
            refreshAlert.addButton(withTitle: "😂")
            refreshAlert.addButton(withTitle: "💩")
            refreshAlert.addButton(withTitle: "😡")
            refreshAlert.addButton(withTitle: "😎")
            refreshAlert.show()
            self.playSound(songName: "Friday")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopPlayer() {
        player?.stop();
    }
    
    func playSound(songName:String) {
        nowPlaying.text = songPlaying
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

