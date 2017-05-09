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
class ViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var spotifyPlayer: SPTAudioStreamingController?
    var loginUrl: URL?
    
    func setup() {
        SPTAuth.defaultInstance().clientID = "9f0cac5d230c4877a2a769febe804681"
        SPTAuth.defaultInstance().redirectURL = URL(string: "soundwich://callback")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }
    
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
        
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: nil, object: nil)
    }
    
    func updateAfterFirstLogin () {
        if let sessionObj:AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
    func initializePlayer(authSession:SPTSession){
        if self.spotifyPlayer == nil {
            self.spotifyPlayer = SPTAudioStreamingController.sharedInstance()
            self.spotifyPlayer!.playbackDelegate = self
            self.spotifyPlayer!.delegate = self
            try! spotifyPlayer!.start(withClientId: auth.clientID)
            self.spotifyPlayer!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.spotifyPlayer?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
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
    
    @IBAction func fetchRequest(_ sender: Any) {
        let con = Connection()
        con.test()
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

