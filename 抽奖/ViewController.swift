//
//  ViewController.swift
//  抽奖
//
//  Created by 菠菜 on 15/2/23.
//  Copyright (c) 2015年 bobo. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController,UIGestureRecognizerDelegate{
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    @IBOutlet var bgMusic: UIButton!
    var playImage=UIImage(named: "play.png")
    var pauseImage=UIImage(named: "pause.png")
    var buttomState=true
    
    @IBOutlet var numberText: UILabel!
    @IBOutlet var imageText: UILabel!
    func playBgMusic(){
        let musicPath=NSBundle.mainBundle().pathForResource("Music_background", ofType: "mp3")
        let url=NSURL(fileURLWithPath: musicPath!)
        audioPlayer=try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer.numberOfLoops = -1
        audioPlayer.volume=0.7
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
    }
    func stopBgMusic(){
        if buttomState==true{
        audioPlayer.pause()
        }
        
        
    }
    func playButtonMusic(){
        let musicPath=NSBundle.mainBundle().pathForResource("Button", ofType: "wav")
        let url=NSURL(fileURLWithPath: musicPath!)
        audioPlayer2=try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer2.numberOfLoops = 1
        audioPlayer2.volume=2
        audioPlayer2.prepareToPlay()
        audioPlayer2.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.interactivePopGestureRecognizer!.enabled=false
    
            playBgMusic()
          }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func button1Clicked(sender: AnyObject) {
        playButtonMusic()
      stopBgMusic()
        
    }

    @IBAction func button2Clicked(sender: AnyObject) {
        playButtonMusic()
       stopBgMusic()
      
    }
   
    
    @IBAction func bgMusic(sender: AnyObject) {
        if buttomState==false{
        playBgMusic()
            buttomState=true
            bgMusic.setImage(playImage, forState: UIControlState.Normal)
                   }
        else{
            stopBgMusic()
            buttomState=false
            bgMusic.setImage(pauseImage! , forState: UIControlState.Normal)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

