//
//  NumberResultViewController.swift
//  抽奖
//
//  Created by 菠菜 on 15/3/4.
//  Copyright (c) 2015年 bobo. All rights reserved.
//

import UIKit
import AVFoundation
class NumberResultViewController: UIViewController {
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
    var everyGetNumberList=[Int]()//分批抽取
    var startTime=0
    //var waitingEnd=false
    var timer : NSTimer? = nil
    @IBOutlet var titleLabel: UILabel!
   // @IBOutlet var prizeNameLabel: UILabel!
   // @IBOutlet var numberResultLabel: UILabel!
    @IBOutlet var fireworksImage: UIImageView!
    @IBOutlet var waitingImage: UIImageView!
    
    @IBOutlet var congratulationImage: UIImageView!
    @IBOutlet var buttonTitleLabel: UILabel!
    @IBOutlet var numberResultTextField: UITextView!
    
    @IBOutlet var backgroundView: UIImageView!
    
    @IBOutlet var startButton: UIButton!

    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        //文字大小适配
//        if totalCount>99{
//            numberResultTextField.font=UIFont(name: "FZLTTHJW--GB1-0", size: 45)
//            
//        }
//        
       let url = NSBundle.mainBundle().URLForResource("xingxing_yuan_wubeijing", withExtension: "gif")
       let imageData = NSData(contentsOfURL: url!)
        
        fireworksImage.image=UIImage.gifWithData(imageData!)
        let url2=NSBundle.mainBundle().URLForResource("waitingCat", withExtension: "gif")
        let imageData2 = NSData(contentsOfURL: url2!)
        waitingImage.image=UIImage.gifWithData(imageData2!)
        let url3=NSBundle.mainBundle().URLForResource("congratulation", withExtension: "gif")
        let imageData3 = NSData(contentsOfURL: url3!)
        congratulationImage.image=UIImage.gifWithData(imageData3!)

        //buttonTitleLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 23)
        //titleLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 26)
        //prizeNameLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 22)
        //numberResultTextField.font=UIFont(name: "FZLTTHJW--GB1-0", size: 80)
        //insertBlurView(backgroundView, style: UIBlurEffectStyle.Light)
        //
     // println("值是\(testNum)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            
            if selectedWay==1{
                               timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector:"changeNumber_selectedWay2", userInfo: nil, repeats: true)
               // onceGetResult()
            }
            else{
               timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector:"changeNumber", userInfo: nil, repeats: true)
                
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
            }
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
           // prizeNameLabel.text=""
           // titleLabel.text="猜猜谁是幸运儿？"
             //titleLabel.textColor=UIColor.blackColor()
            fireworksImage.hidden=true
            congratulationImage.hidden=true
            startTime=Int(NSDate.timeIntervalSinceReferenceDate())
            playWaitingMusic()
           timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector:"changeNumber", userInfo: nil, repeats: true)
            //everyGetResult()
            if everyGetStartPoint==selectedCount{
                finalState=2
                buttonTitleLabel.text="结束"
                
            }
            
        }
    }
    func onceGetResult(){
//        if selectedCount>2{
//            numberResultTextField.font=UIFont(name: "FZLTTHJW--GB1-0", size: 40)
//            
//        }

        var resultList=[Int]()
        var equal=false
        var result=String()
        for var i=selectedCount;i>0;i--
        {
            //println("新的一次循环时i为\(i)")
        let result=Int(arc4random_uniform(totalCount))+1
            //println("这次的随机数为\(result)")
          
            
            if prizeRepeatBool{
                resultList.append(result)
            }
            else{
                for num in resultList{
                    if num==result{
                        equal=true
                        break
                    }
                    
                }
                if equal==false{
                    resultList.append(result)
                    //println("找到一个")
                }
                else{
                    i++
                    equal=false
                    //println("i的值是\(i)")
                }
            }
        }
        for var i=0;i<resultList.count;i++
        {
            if i==(resultList.count-1){
                result+="\(resultList[i])"
            }
            else{
        result+="\(resultList[i]),"
            }
        }
        numberResultTextField.text=result
        playWinMusic()
        //prizeNameLabel.text=prizeName
       // let characterNum=prizeName.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)

        var prizeTitle=String()
        for element in prizeName.characters{
            prizeTitle+="\(element) "
        }
        titleLabel.text="\(prizeTitle)"
         titleLabel.textColor=UIColor(red: 255/255, green: 204/255, blue: 153/255, alpha: 1)
//        if characterNum>10{
//              titleLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 30)
//        }
//        else{
//        titleLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 40)
//        }
            fireworksImage.hidden=false
        congratulationImage.hidden=false
        finalState=2
        buttonTitleLabel.text="结束"
      
        
    }
    func everyGetResult(){
        
        var loop=true
        var equal:Bool//是否有重复的
        while(loop){
            equal=false
            let result=Int(arc4random_uniform(totalCount))+1
            //println("产生的随机数为\(result)")
            if prizeRepeatBool{
                numberResultTextField.text="\(result)"
                loop=false
                everyGetStartPoint++
            }
            else{
                for num in everyGetNumberList{
                    if num==result{
                        equal=true
                        
                        break
                    }
                    
                }
                if equal==false{
                    numberResultTextField.text="\(result)"
                                        everyGetNumberList.append(result)
                                        loop=false
                    everyGetStartPoint++
                    //playWinMusic()
                   // println("找到一个")
                }
                else{
                    
                    loop=true
                    //println("i的值是\(i)")
                }
            }
        }
    }
    func changeNumber(){
        let nowTime=Int(NSDate.timeIntervalSinceReferenceDate())
        //println("\(nowTime-startTime)")
        if((nowTime-startTime)<progressTime){
     let result=Int(arc4random_uniform(totalCount))+1
        numberResultTextField.text="\(result)"
                insertBlurView(backgroundView, style:UIBlurEffectStyle.Dark)
           
            buttonTitleLabel.hidden=true
            startButton.hidden=true
            titleLabel.hidden=true
           waitingImage.hidden=false
        }
        else{
            for subview in backgroundView.subviews{
                subview.removeFromSuperview()
            }
            
            titleLabel.hidden=false
            buttonTitleLabel.hidden=false
            startButton.hidden=false
            timer?.invalidate()
            audioPlayer.stop()
            playWinMusic()
           // prizeNameLabel.text=prizeName
            var prizeTitle=String()
            for element in prizeName.characters{
                prizeTitle+="\(element) "
            }
            titleLabel.text="\(prizeTitle)"
            titleLabel.textColor=UIColor(red: 255/255, green: 204/255, blue: 153/255, alpha: 1)
//            let characterNum=prizeName.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)
//
//            if characterNum>10{
//                titleLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 30)
//            }
//            else{
//                titleLabel.font=UIFont(name: "FZLTTHJW--GB1-0", size: 40)
//            }
//
           
            fireworksImage.hidden=false
            congratulationImage.hidden=false
            waitingImage.hidden=true
            everyGetResult()
            
            //waitingEnd=true
        }
    }
    func changeNumber_selectedWay2(){
        let nowTime=Int(NSDate.timeIntervalSinceReferenceDate())
        //println("\(nowTime-startTime)")
        if((nowTime-startTime)<progressTime){
            let result=Int(arc4random_uniform(totalCount))+1
            numberResultTextField.text="\(result)"
           
                insertBlurView(backgroundView, style:UIBlurEffectStyle.Dark)
           
            buttonTitleLabel.hidden=true
            startButton.hidden=true
            titleLabel.hidden=true
            waitingImage.hidden=false
            
        }
        else{
            
            timer?.invalidate()
            audioPlayer.stop()
            onceGetResult()
            for subview in backgroundView.subviews{
                subview.removeFromSuperview()
            }
            buttonTitleLabel.hidden=false
            startButton.hidden=false
            titleLabel.hidden=false
            waitingImage.hidden=true
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
