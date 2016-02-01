//
//  SettingViewController.swift
//  抽奖
//
//  Created by 菠菜 on 15/3/3.
//  Copyright (c) 2015年 bobo. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import MediaPlayer
class SettingViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate{
    var audioPlayer2:AVAudioPlayer!
    
    @IBOutlet var okText: UILabel!
    @IBOutlet var imageText: UILabel!
    @IBOutlet var selectText: UILabel!
    @IBOutlet var totalText: UILabel!
    @IBOutlet var timeText: UILabel!
    @IBOutlet var prizeText: UILabel!
    //@IBOutlet var settingBar: UINavigationItem!
    @IBOutlet var totalCount: UITextField!
    @IBOutlet var selectedCount: UITextField!
    @IBOutlet var progressTimeTextField: UITextField!
    @IBOutlet var prizeNameTextField: UITextField!
    @IBOutlet var repeatText: UILabel!
    
    @IBOutlet var shelterImageView: UIImageView!
    @IBOutlet var selectedStepper: UIStepper!
    @IBOutlet var totalStepper: UIStepper!
    @IBOutlet var timeStepper: UIStepper!
    
    @IBOutlet var prizerRepeatSwich: UISwitch!
    
    //@IBOutlet var SettingBar: UINavigationItem!
    @IBOutlet var imageScrollView: UIScrollView!
    var prizeRepeatBool=true
   
    var photoLibray=[UIImageView]()//收集选中的照片
    
   
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
        totalCountAction()
        selectCountAction()
        timeCountAction()
        
        repeatAction()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blue-navigation-bar.png"), forBarMetrics:UIBarMetrics.Default)
        
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes=navigationTitleAttribute as? [String : AnyObject]
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate=self
  
       
        self.navigationController?.interactivePopGestureRecognizer!.enabled=true
//        imageText.font=UIFont(name: "FZLTXHK", size: 19)
//        totalText.font=UIFont(name: "FZLTXHK", size: 19)
//        selectText.font=UIFont(name: "FZLTXHK", size: 19)
//        repeatText.font=UIFont(name: "FZLTXHK", size: 19)
//        timeText.font=UIFont(name: "FZLTXHK", size: 19)
//        prizeText.font=UIFont(name: "FZLTXHK", size: 19)
//        prizeNameTextField.font=UIFont(name: "FZLTXHK", size: 20)
//        totalCount.font=UIFont(name: "FZLTXHK", size: 20)
//        selectedCount.font=UIFont(name: "FZLTXHK", size: 20)
//        progressTimeTextField.font=UIFont(name: "FZLTXHK", size: 20)
        //okText.font=UIFont(name: "FZLTTHJW--GB1-0", size: 25)
        //更换navigationController字体样式
        //let navigationFontDescriptor = UIFontDescriptor(name: "FZLTTHJW--GB1-0", size: 20)
        //let navigationFont = UIFont(descriptor: navigationFontDescriptor, size:20)
        
        let navigationColor=UIColor.whiteColor()
        let navagitionTextAttributes = [
            NSForegroundColorAttributeName:navigationColor,
            //NSFontAttributeName:navigationFont
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes=navagitionTextAttributes



            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func okClicked(sender: AnyObject) {
        playButtonMusic()
        
        if !finalCheck() {
            let snum=Int(selectedCount.text!)!
            let cnum=Int(totalCount.text!)!
            let time=Int(progressTimeTextField.text!)!
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
                let buttonText="朕已阅"
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
            else if snum>=Int(totalCount.text!
                
                
                )!{
                let alertString="抽取人数不得大于等于参与人数"
                let messageText="The number of participator should not more than the total number"
                let buttonText="朕已阅"
                showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
                selectedCount.becomeFirstResponder()
            }
            
        }
        if photoLibray.count != Int(totalCount.text!)!{
            //println("照片的数量为\(photoLibray.count)！！显示的总人数为\(totalCount.text.toInt(let)
            let alertString="请上传\(Int(Int(totalCount.text!)!))张照片"
            let messageText="Please upload photos"
            let buttonText="朕已阅"
            self.showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
        }
        else{
            self.performSegueWithIdentifier("ImageResultViewController", sender: self)
        }
                     // println("当点击OK时显示的值\(totalCount.text)")
    
    }
    //数据违规检查
    func finalCheck()->Bool{
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
   
    //点击空白处
    @IBAction func tapClicked(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
   
    
    @IBAction func totalCountCheck(sender: AnyObject) {
        let num=Int(totalCount.text!)
        if num<2{
            let alertString="参与人数最少2人"
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
        let num=Int(selectedCount.text!)!
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
        else if num>=Int(totalCount.text!)!{
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
            // Fallback on earlier versions

        // Create the action.
        
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
                
            }
       
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func prizeNameCheck(sender: AnyObject) {
        let characterNum=prizeNameTextField.text!.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)
        if characterNum>20{
            let alertString="获奖名称字数不能大于10"
            let messageText="The number of prize name should not more than 10"
            let buttonText="朕已阅"
            showSimpleAlert(alertString, messageText:messageText, cancelButtonText: buttonText)
            
        }
        
    }
    @IBAction func imageSendClicked(sender: AnyObject) {
        
        photoLibray.removeAll(keepCapacity: false)
        
        let pickerController = DKImagePickerController()
        
        for subview in self.imageScrollView.subviews{
            subview.removeFromSuperview()
        }
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
           // print("didSelectAssets")
            //print(assets)
             //print("2）subviews的数量为\(self.imageScrollView.subviews.count)\n")
            
            //self.shelterImageView.hidden=true
            
            //self.imageScrollView.subviews.map(){$0.removeFromSuperview}
            
            for (index, asset) in assets.enumerate() {
                        let imageWidth:CGFloat=self.imageScrollView.bounds.width / 2
                        let imageHeight: CGFloat = self.imageScrollView.bounds.height
                        //let count=assets.count
                        //CGFloat(index) * imageHeight
                asset.fetchImageWithSize(CGSize(width: imageWidth, height:imageHeight),completeBlock: { image, info in
                    let imageView=UIImageView(image: image)
                    //print("生成了图片")
                    imageView.layer.borderWidth=1
                    imageView.layer.borderColor=UIColor.whiteColor().CGColor
                    imageView.contentMode = UIViewContentMode.ScaleAspectFit
                    imageView.frame = CGRect(x: CGFloat(index) * imageWidth, y: 0, width:imageWidth, height: imageHeight)
                    
                    self.imageScrollView.addSubview(imageView)
                    self.photoLibray.append(imageView)
            //print("3）subviews的数量为\(self.imageScrollView.subviews.count)\n")
                    self.imageScrollView.contentSize.width = CGRectGetMaxX((self.imageScrollView.subviews.last! as UIView).frame)
                    //print("最后一个的位置\(CGRectGetMaxX((self.imageScrollView.subviews.last! as UIView).frame))\n")

                })
    
                }
                                                  //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(pickerController, animated: true) {}

    }
//    func showSystemController() {
//        let pickerController = UIImagePickerController()
//        pickerController.delegate = self
//        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        pickerController.mediaTypes = [kUTTypeImage,kUTTypeMovie]
//        
//        self.presentViewController(pickerController, animated: true) {}
//    }
    
//    // 使用自定义的图片选取器
//    func showCustomController() {
//        let pickerController = DKImagePickerController(maxCount: Int(totalCount.text!)!)
//        pickerController.pickerDelegate = self
//        self.presentViewController(pickerController, animated: true) {}
//    }
//    
//       func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        //println("调用了这里")
//        let mediaType = info[UIImagePickerControllerMediaType] as! NSString!
//       // println(mediaType)
//            let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage!
//            imageScrollView.subviews.map(){$0.removeFromSuperview()}
//            let imageView = UIImageView(image: selectedImage)
//            imageView.contentMode = UIViewContentMode.ScaleAspectFit
//            imageView.frame = imageScrollView.bounds
//            imageScrollView.addSubview(imageView)
//            
//        picker.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    // MARK: - DKImagePickerControllerDelegate methods
//    // 取消时的回调
//    func imagePickerControllerCancelled() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    // 选择图片并确定后的回调
//    func imagePickerControllerDidSelectedAssets(assets: [DKAsset]!) {
//        shelterImageView.hidden=true
//        imageScrollView.subviews.map(){$0.removeFromSuperview}
//        
//        for (index, asset) in assets.enumerate() {
//            let imageWidth:CGFloat=imageScrollView.bounds.width / 2
//            let imageHeight: CGFloat = imageScrollView.bounds.height
//            //let count=assets.count
//            //CGFloat(index) * imageHeight
//            let imageView = UIImageView(image: asset.thumbnailImage)
//            
//            imageView.layer.borderWidth=1
//            imageView.layer.borderColor=UIColor.whiteColor().CGColor
//            imageView.contentMode = UIViewContentMode.ScaleAspectFit
//            imageView.frame = CGRect(x: CGFloat(index) * imageWidth, y: 0, width:imageWidth, height: imageHeight)
//           
//            imageScrollView.addSubview(imageView)
//            photoLibray.append(imageView)
//        }
//        imageScrollView.contentSize.width = CGRectGetMaxX((imageScrollView.subviews.last! as UIView).frame)
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//
//    
//    
    /*
    // MARK: - Navigation
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                if  segue.identifier=="ImageResultViewController"{
           // println("跳转成功")
            let obj=segue.destinationViewController as! ImageResultViewController
            obj.totalCount=UInt32(self.totalCount.text!)!
            obj.selectedCount=Int(self.selectedCount.text!)!
            obj.prizeName=self.prizeNameTextField.text!
            obj.prizeRepeatBool=self.prizeRepeatBool
            obj.progressTime=Int(self.progressTimeTextField.text!)!
            obj.photoLibray=self.photoLibray
                        //println("传值前是\(obj.totalCount)")
        }
        
        
    }
}
