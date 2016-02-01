//
//  ImageResultViewController.swift
//  抽奖
//
//  Created by 菠菜 on 15/3/4.
//  Copyright (c) 2015年 bobo. All rights reserved.
//

import UIKit
import AVFoundation
class ImageResultViewController: UIViewController {
    var audioPlayer2:AVAudioPlayer!
    var audioPlayer:AVAudioPlayer!
    var audioPlayer3:AVAudioPlayer!
    var totalCount:UInt32=1
    var selectedCount=1
    var prizeName=String()
    var progressTime=1
    var selectedWay=1
    var prizeRepeatBool=true
    var finalState=0//0代表还未开始，1代表继续，2代表结束
    var everyGetStartPoint=0//分批抽取的当前起点
    var everyGetImageList=[UIImage]()//分批抽取
    var startTime=0
    //var waitingEnd=false
    var timer : NSTimer? = nil
    var photoLibray=[UIImageView]()//用户上传图片
    
    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    //@IBOutlet var prizeNameLabel: UILabel!
    @IBOutlet var buttonTitleLabel: UILabel!

    @IBOutlet var startButton: UIButton!
  //  @IBOutlet var fireworksImage: UIImageView!
   // @IBOutlet var waitingImage: UIImageView!
    @IBOutlet var congratulationImage: UIImageView!
    @IBOutlet var resultImageView: UIImageView!
    override func viewDidLoad() {
         super.viewDidLoad()
        if photoLibray.count>0{
        resultImageView.image=photoLibray[0].image
        }
//        var url = NSBundle.mainBundle().URLForResource("image_firework2", withExtension: "gif")
//        var imageData = NSData(contentsOfURL: url!)
//        fireworksImage.image=UIImage.animatedImageWithData(imageData!)

        buttonTitleLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 23)
        
        let url3=NSBundle.mainBundle().URLForResource("congratulation", withExtension: "gif")
        let imageData3 = NSData(contentsOfURL: url3!)
        congratulationImage.image=UIImage.gifWithData(imageData3!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func playWaitingMusic(){
        let musicPath=NSBundle.mainBundle().pathForResource("Music_progress", ofType: "mp3")
        let url=NSURL(fileURLWithPath: musicPath!)
        audioPlayer=try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer.numberOfLoops = 1
        audioPlayer.volume=2
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    func playWinMusic(){
        let musicPath=NSBundle.mainBundle().pathForResource("Music_win", ofType: "wav")
        let url=NSURL(fileURLWithPath: musicPath!)
        audioPlayer3=try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer3.numberOfLoops = 0
        audioPlayer3.volume=2
        audioPlayer3.prepareToPlay()
        audioPlayer3.play()
    }

    func insertBlurView (view: UIView,  style: UIBlurEffectStyle) {
        view.backgroundColor = UIColor.clearColor()
        
       
            let blurEffect = UIBlurEffect(style: style)
      
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: 0, width: view.bounds.width+60, height: view.bounds.height+100)
        view.insertSubview(blurEffectView, atIndex: 0)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

    @IBAction func startClicked(sender: AnyObject) {
        if finalState==0{
            
            playWaitingMusic()
            //playButtonMusic()
            
            startTime=Int(NSDate.timeIntervalSinceReferenceDate())
                            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector:"changeImage", userInfo: nil, repeats: true)
                everyGetResult()
                if everyGetStartPoint==selectedCount{
                    // playWinMusic()
                    finalState=2
                    buttonTitleLabel.text="结束"
                }
                else{
                    //playWinMusic()
                    buttonTitleLabel.text="下一个"
                    finalState=1
                }
           // }
        }
        else if finalState==2{
            //
            playButtonMusic()
            let myStoryboard=self.storyboard
            let anotherView:UIViewController=(myStoryboard?.instantiateViewControllerWithIdentifier("firstViewController"))!as UIViewController
            self.presentViewController(anotherView, animated: true, completion: nil)
            // println("错误就是它")
        }
        else if finalState==1{
            //println("错误就是它")
            //prizeNameLabel.text=""
            titleLabel.text="猜猜谁是幸运儿？"
            titleLabel.textColor=UIColor.blackColor()
           // fireworksImage.hidden=true
            congratulationImage.hidden=true
           // prizeNameLabel.hidden=true
            startTime=Int(NSDate.timeIntervalSinceReferenceDate())
            playWaitingMusic()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector:"changeImage", userInfo: nil, repeats: true)
            everyGetResult()
            if everyGetStartPoint==selectedCount{
                finalState=2
                buttonTitleLabel.text="结束"
            }
            
            
        }

    }
    func everyGetResult(){
        var loop=true
        var equal=false//是否有重复的
        while(loop){
            
            let result=Int(arc4random_uniform(totalCount))
            if prizeRepeatBool{
               resultImageView.image=photoLibray[result].image
                loop=false
                everyGetStartPoint++
            }
            else{
                for num in everyGetImageList{
                    if num==photoLibray[result].image{
                        equal=true
                        break
                    }
                    
                }
                if equal==false{
                    resultImageView.image=photoLibray[result].image
                    everyGetImageList.append(photoLibray[result].image!)
                    loop=false
                    everyGetStartPoint++
                    //playWinMusic()
                    //println("找到一个")
                }
                else{
                    
                    loop=true
                    //println("i的值是\(i)")
                }
            }
        }
    }
    func changeImage(){
        let nowTime=Int(NSDate.timeIntervalSinceReferenceDate())
        //println("\(nowTime-startTime)")
        if((nowTime-startTime)<progressTime){
            let result=Int(arc4random_uniform(totalCount))
           resultImageView.image=photoLibray[result].image
            //resultImageView.image=photoLibray[0].image
            
                insertBlurView(backgroundView, style: UIBlurEffectStyle.Dark)
           
            startButton.hidden=true
            buttonTitleLabel.hidden=true
            titleLabel.hidden=true
            //waitingImage.hidden=false
        }
        else{
            for subview in backgroundView.subviews{
                subview.removeFromSuperview()
            }
            titleLabel.hidden=false
            startButton.hidden=false
            buttonTitleLabel.hidden=false
            timer?.invalidate()
            audioPlayer.stop()
           playWinMusic()
            //prizeNameLabel.text=prizeName
           // prizeNameLabel.hidden=false
            var prizeTitle=String()
            for element in prizeName.characters{
                prizeTitle+="\(element) "
            }
            titleLabel.text="\(prizeTitle)"
            titleLabel.textColor=UIColor(red: 255/255, green: 204/255, blue: 153/255, alpha: 1)
            let characterNum=prizeName.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)
            
            if characterNum>10{
                titleLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 30)
            }
            else{
                titleLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 40)
            }
            
           // fireworksImage.hidden=false
            congratulationImage.hidden=false
            //waitingImage.hidden=true
            //waitingEnd=true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
