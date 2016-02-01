//
//  NumberSettingViewController.swift
//  抽奖
//
//  Created by 菠菜 on 15/3/3.
//  Copyright (c) 2015年 bobo. All rights reserved.
//

import UIKit
import AVFoundation
class NumberSettingViewController: UIViewController,UIGestureRecognizerDelegate{
    var audioPlayer2:AVAudioPlayer!
    
    @IBOutlet var totalCount: UITextField!
    @IBOutlet var selectedCount: UITextField!
    @IBOutlet var progressTimeTextField: UITextField!
    @IBOutlet var prizeNameTextField: UITextField!
    
    @IBOutlet var selectedStepper: UIStepper!
    @IBOutlet var totalStepper: UIStepper!
    @IBOutlet var timeStepper: UIStepper!
    
    @IBOutlet var prizerRepeatSwich: UISwitch!
    @IBOutlet var selectedSegmentedControl: UISegmentedControl!
    
    @IBOutlet var totalText: UILabel!
    @IBOutlet var selectedText: UILabel!
    @IBOutlet var select_wayText: UILabel!
    @IBOutlet var timeText: UILabel!
    @IBOutlet var prizeText: UILabel!
    @IBOutlet var repeatText: UILabel!
    @IBOutlet var okText: UILabel!
    
    
    
    var prizeRepeatBool=true
    var selectedWayIndex=1
    
    func playButtonMusic(){
        let musicPath=NSBundle.mainBundle().pathForResource("Button", ofType: "wav")
        let url=NSURL(fileURLWithPath: musicPath!)
        audioPlayer2=try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer2.numberOfLoops = 1
        audioPlayer2.volume=1
        audioPlayer2.prepareToPlay()
        audioPlayer2.play()
    }
    
    func totalCountAction(){
        totalStepper.value=Double(Int(totalCount.text!)!)
       // println("加减控件的值为\(totalStepper.value)输入框的值为\(totalCount.text)")
        totalStepper.minimumValue=2
        totalStepper.maximumValue=1000
        totalStepper.stepValue=1
        totalCount.text="\(Int(totalStepper.value))"
         totalStepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
    }
    func selectCountAction(){
        
        selectedStepper.value=Double(Int(selectedCount.text!)!)
        selectedStepper.minimumValue=1
        selectedStepper.maximumValue=1000
        selectedStepper.stepValue=1
        selectedCount.text="\(Int(selectedStepper.value))"
        selectedStepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
    }
    func timeCountAction(){
        timeStepper.value=Double(Int(progressTimeTextField.text!)!)
         timeStepper.minimumValue=2
         timeStepper.maximumValue=6
         timeStepper.stepValue=1
        progressTimeTextField.text="\(Int(timeStepper.value))"
         timeStepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
    }
    func repeatAction(){
        prizerRepeatSwich.setOn(true, animated: false)
        
        prizerRepeatSwich.addTarget(self, action: "switchValueDidChange:", forControlEvents: .ValueChanged)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    //totalText.font=UIFont(name: "FZHTTH", size: 20)
     totalCountAction()
        selectCountAction()
        timeCountAction()
        selectedWay()
        repeatAction()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blue-navigation-bar.png"), forBarMetrics:UIBarMetrics.Default)
        
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes=navigationTitleAttribute as? [String : AnyObject]
        

        self.navigationController?.interactivePopGestureRecognizer!.delegate=self
        self.navigationController?.navigationBarHidden=false
        self.navigationController?.interactivePopGestureRecognizer!.enabled=true
       // self.navigationController?.interactivePopGestureRecognizer.enabled=true
        // Do any additional setup after loading the view.
//        select_wayText.font=UIFont(name: "FZLTXHK", size: 19)
//        totalText.font=UIFont(name: "FZLTXHK", size: 19)
//        selectedText.font=UIFont(name: "FZLTXHK", size: 19)
//        repeatText.font=UIFont(name: "FZLTXHK", size: 19)
//        timeText.font=UIFont(name: "FZLTXHK", size: 19)
//        prizeText.font=UIFont(name: "FZLTXHK", size: 19)
//        prizeNameTextField.font=UIFont(name: "FZLTXHK", size: 20)
//        totalCount.font=UIFont(name: "FZLTXHK", size: 20)
//        selectedCount.font=UIFont(name: "FZLTXHK", size: 20)
//        progressTimeTextField.font=UIFont(name: "FZLTXHK", size: 20)
        //okText.font=UIFont(name: "FZLTTHJW--GB1-0", size: 25)
        
        //更换segmentController字体样式
     
//        let segmentFontDescriptor = UIFontDescriptor(name: "FZLTXHK", size: 16)
//        let segmentFont = UIFont(descriptor: segmentFontDescriptor, size:16)
//        
//        let normalTextAttributes = [
//            
//            NSFontAttributeName: segmentFont
//        ]

        //selectedSegmentedControl.setTitleTextAttributes(normalTextAttributes, forState: UIControlState.Normal)
        //更换navigationController字体样式
        //let navigationFontDescriptor = UIFontDescriptor(name: "FZLTTHJW--GB1-0", size: 20)
       // let navigationFont = UIFont(descriptor: navigationFontDescriptor, size:20)
        let navigationColor=UIColor.whiteColor()
        let navagitionTextAttributes = [
            NSForegroundColorAttributeName:navigationColor,
           // NSFontAttributeName:navigationFont
        ]

        self.navigationController?.navigationBar.titleTextAttributes=navagitionTextAttributes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okClicked(sender: AnyObject) {
        playButtonMusic()

        if !finalCheck() {
            let snum=Int(selectedCount.text!)
            let cnum=Int(totalCount.text!)
            let time=Int(progressTimeTextField.text!)
            if time<2{
                let alertString="抽奖时间最短2秒"
                let messageText="At least 2 second"
                let buttonText="朕已阅"
                showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
                progressTimeTextField.becomeFirstResponder()
            }
            else if time>6 {
                let alertString="抽奖时间最多6秒"
                let messageText="The longest time no more than 6 seconds"
                let buttonText="朕已阅"
                showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
                progressTimeTextField.becomeFirstResponder()
            }

            if cnum<2{
                let alertString="参与人数最少2人"
                let messageText="At least 2 people"
                let buttonText="朕已阅"
                self.showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
                // println("我在这里")
                totalCount.becomeFirstResponder()
            }
            else if cnum>1000 {
                let alertString="参与人数最多1000人"
                let messageText="The most number is 1000"
                let
                buttonText="朕已阅"
                showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
                totalCount.becomeFirstResponder()
            }
            

            if snum<1{
                
                let alertString="抽取人数最少1人"
                let messageText="At least 1 people"
                let buttonText="朕已阅"
                showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
                selectedCount.becomeFirstResponder()
            }
            else if snum>1000 {
                let alertString="参与人数最多1000人"
                let messageText="The most number is 1000"
                let buttonText="朕已阅"
                showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
                selectedCount.becomeFirstResponder()
            }
            else if snum>=Int(totalCount.text!){
                let alertString="抽取人数不得大于等于参与人数"
                let messageText="The number of participator should not more than the total number"
                let
                
                
                
                
                
                
                buttonText="朕已阅"
                showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
                selectedCount.becomeFirstResponder()
            }

            
        }
               else{
            self.performSegueWithIdentifier("NumberResultViewController", sender: self)
        }

        
    }
    //数据违规检查
    func finalCheck()
        
        ->Bool{
        let totalNum=Int(totalCount.text!)
        let SelectetdNum=Int(selectedCount.text!)
        let time=Int(progressTimeTextField.text!)
        if totalCount.text==""||selectedCount.text==""||progressTimeTextField.text==""{
            return false
        }
        else if totalNum<2 || totalNum>1000 || SelectetdNum>=totalNum || SelectetdNum<1 || time<2 || time>6 {
            return false
        }
        else{
            return true
        }
    }

    func stepperValueDidChange(stepper: UIStepper) {
        //NSLog("A stepper changed its value: \(stepper).")
//        totalStepper.value=Double(totalCount.text.toInt()!)
//        selectedStepper.value=Double(selectedCount.text.toInt()!)
//        timeStepper.value=Double(progressTimeTextField.text.toInt()!)

        // A mapping from a stepper to its associated label.
        let stepperMapping: [UIStepper: UITextField] = [
            totalStepper: totalCount,
            selectedStepper:selectedCount,
            timeStepper:progressTimeTextField
            
        ]
        
        stepperMapping[stepper]!.text = "\(Int(stepper.value))"
    }
    func switchValueDidChange(aSwitch: UISwitch) {
        if aSwitch.on{
            prizeRepeatBool=true
            
        }
        else
        {
            prizeRepeatBool=false
            
        }
    }
    func selectedWay(){
        selectedSegmentedControl.addTarget(self, action: "selectedSegmentDidChange:", forControlEvents: .ValueChanged)
    }
    func selectedSegmentDidChange(segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex==0
        {
            selectedWayIndex=1
            
        }
        else
        {
            selectedWayIndex=2
                    }
    }

    @IBAction func tapClicked(sender: AnyObject) {
    self.view.endEditing(true)
    }
    
    
    @IBAction func totalCountCheck(sender: AnyObject) {
       let num=Int(totalCount.text!)
        if num<2{
            let
            alertString="参与人数最少2人"
            let messageText="At least 2 people"
            let buttonText="朕已阅"
            self.showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
           // println("我在这里")
        }
        else if num>1000 {
            let alertString="参与人数最多1000人"
            let messageText="The most number is 1000"

            let buttonText="朕已阅"
            showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
        }
       
       selectedCount.becomeFirstResponder()
    }
   
    @IBAction func selectedCountCheck(sender: AnyObject) {
        let
        num=Int(selectedCount.text!)
        if num<1{
            let alertString="抽取人数最少1人"
       let messageText="At least 1 people"
            let buttonText="朕已阅"
            showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
        }
        else if num>1000 {
   
            let alertString="参与人数最多1000人"
            let messageText="The most number is 1000"
            let buttonText="朕已阅"
            showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
            
        }
        else if num>=Int(totalCount.text!){
            let alertString="抽取人数不得大于等于参与人数"
            let messageText="The number of participator should not more than the total number"
            let buttonText="朕已阅"
            showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
        }
        progressTimeTextField.becomeFirstResponder()
    }
    
    @IBAction func progressTimeCheck(sender: AnyObject) {
        let time=Int(progressTimeTextField.text!)
        if time<2{
            let alertString="抽奖时间最短2秒"
            let messageText="At least 2 second"
            let buttonText="朕已阅"
            showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
        }
        else if time>6 {
            let alertString="抽奖时间最多6秒"
            let messageText="The longest time no more than 6 seconds"
            let buttonText="朕已阅"
            showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
            
        }
        prizeNameTextField.becomeFirstResponder()

    }
    //弹出框
    func showSimpleAlert(titleText:String,messageText:String,cancelButtonText:String){
        let title = NSLocalizedString(titleText, comment: "")
        let message = NSLocalizedString(messageText, comment: "")
        let cancelButtonTitle = NSLocalizedString(cancelButtonText, comment: "")
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
               // Create the action.
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
        }
        
               
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }

        
    func prizeNameCheck(sender: AnyObject) {
        let characterNum=prizeNameTextField.text!.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)
        if characterNum>20{
            let alertString="获奖名称字数不能大于10"
            let messageText="The number of prize name should not more than 10"
            let buttonText="朕已阅"
            showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
            
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
           if  segue.identifier=="NumberResultViewController"{
           // println("跳转成功")
            
            let obj=segue.destinationViewController as! NumberResultViewController
            if finalCheck(){
                let num=Int(self.totalCount.text!)!
                
                obj.totalCount=UInt32(num)
            obj.selectedCount=Int(self.selectedCount.text!)!
            obj.prizeName=self.prizeNameTextField.text!
            obj.prizeRepeatBool=self.prizeRepeatBool
            obj.progressTime=Int(self.progressTimeTextField.text!)!
                obj.selectedWay=self.selectedWayIndex}
            //println("传值前是\(obj.totalCount)")
        }
        
        
    }

}