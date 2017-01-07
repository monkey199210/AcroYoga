//
//  EditViewController.swift
//  AcroYoga
//
//  Created by SCAR on 3/21/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit
import AnimatedTextInput
import MRProgress

class EditViewController: UIViewController,  FusumaDelegate {
    @IBOutlet var textInputs: [AnimatedTextInput]!
    @IBOutlet weak var image0: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var plusPhotoBtn1: UIButton!
    
    @IBOutlet weak var plusPhotoBtn2: UIButton!
    
    @IBOutlet weak var plusPhotoBtn3: UIButton!
    
    @IBOutlet var loadingIndicators: [UIActivityIndicatorView]!
    @IBOutlet weak var flycheckBox: VKCheckbox!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightTextView: UITextField!
    
    @IBOutlet weak var baseCheck: VKCheckbox!
    @IBOutlet weak var lbaseCheck: VKCheckbox!
    @IBOutlet weak var handCheck: VKCheckbox!
    @IBOutlet weak var whipCheck: VKCheckbox!
    @IBOutlet weak var popCheck: VKCheckbox!
    @IBOutlet weak var bothCheck: VKCheckbox!
    
    var btnIndex:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.configureScrollView()
        self.initImageViews()
        configure()
        
    }
    
    func configure()
    {
        if let user = UserProfile.currentUser() {
            configureWithUser(user)
        }
        FBEvent.onProfileReceived().listen(self, callback: { [unowned self] (user) -> Void in
            self.configureWithUser(user)
            FBEvent.onProfileReceived().removeListener(self)
            })
    }
    func configureWithUser(pUser: AYUser)
    {
        //        ratingView.value = CGFloat((pUser.rate as NSString).floatValue)
        textInputs[0].text = pUser.username
        textInputs[1].text = pUser.phoneNumber
        textInputs[2].text = pUser.description
        //        if pUser.description != ""
        //        {
        //            descriptionTextField.text = pUser.description
        //        }
        if let img1 = pUser.profileMainImage {
            loadingIndicators[0].startAnimating()
            loadingIndicators[0].hidden = false
            UserProfile.getImage(img1, completition:{ (image) -> Void in
                self.image0.image = image
                self.loadingIndicators[0].stopAnimating()
                self.loadingIndicators[0].hidden = true
            })
        }
        if let img2 = pUser.imgpath1 {
            loadingIndicators[1].startAnimating()
            loadingIndicators[1].hidden = false
            UserProfile.getImage(img2, completition:{ (image) -> Void in
                self.image1.image = image
                self.loadingIndicators[1].stopAnimating()
                self.loadingIndicators[1].hidden = true
            })
        }
        if let img3 = pUser.imgpath2 {
            loadingIndicators[2].startAnimating()
            loadingIndicators[2].hidden = false
            UserProfile.getImage(img3, completition:{ (image) -> Void in
                self.image2.image = image
                self.loadingIndicators[2].stopAnimating()
                self.loadingIndicators[2].hidden = true
            })
        }
        weightTextView.text = pUser.acrotype
        if pUser.fly == "0"
        {
            flycheckBox.setOn(false)
            weightLabel.hidden = true
            weightTextView.hidden = true
        }else{
            flycheckBox.setOn(true)
            weightLabel.hidden = false
            weightTextView.hidden = false
            
        }
        if pUser.base == "0"
        {
            baseCheck.setOn(false)
        }else{
            baseCheck.setOn(true)
        }
        if pUser.lbasing == "0"
        {
            lbaseCheck.setOn(false)
        }else{
            lbaseCheck.setOn(true)
        }
        if pUser.hand == "0"
        {
            handCheck.setOn(false)
        }else{
            handCheck.setOn(true)
        }
        if pUser.hand == "0"
        {
            handCheck.setOn(false)
        }else{
            handCheck.setOn(true)
        }
        if pUser.whips == "0"
        {
            whipCheck.setOn(false)
        }else{
            whipCheck.setOn(true)
        }
        if pUser.pops == "0"
        {
            popCheck.setOn(false)
        }else{
            popCheck.setOn(true)
        }
        if pUser.both == "0"
        {
            bothCheck.setOn(false)
        }else{
            bothCheck.setOn(true)
        }
        
    }
    func configureScrollView()
    {
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        
        //Setting the right content size - only height is being calculated depenging on content.
        let height = self.bothCheck.frame.maxY + 30
        let contentSize = CGSizeMake(screenWidth, 800);
        self.scrollView.contentSize = contentSize;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func initImageViews()
    {
        // hidden loadingIndicators
        for i in 0 ..< loadingIndicators.count
        {
            loadingIndicators[i].hidden = true
        }
        
        //        makeRoundTextView(introTextView)
        image0.layer.cornerRadius = 7.0
        image0.clipsToBounds = true
        image1.layer.cornerRadius = 7.0
        image1.clipsToBounds = true
        image2.layer.cornerRadius = 7.0
        image2.clipsToBounds = true
        
        plusPhotoBtn1.layer.cornerRadius = plusPhotoBtn1.frame.size.height/2
        plusPhotoBtn2.layer.cornerRadius = plusPhotoBtn2.frame.size.height/2
        plusPhotoBtn3.layer.cornerRadius = plusPhotoBtn3.frame.size.height/2
        
        textInputs[0].accessibilityLabel = "standard_text_input"
        textInputs[0].placeHolderText = "Full Name"
        
        textInputs[1].placeHolderText = "Phone Number"
        textInputs[1].type = .numeric
        textInputs[2].placeHolderText = "Detail"
        textInputs[2].type = .multiline
        textInputs[2].showCharacterCounterLabel(with: 160)
        
        flycheckBox.checkboxValueChangedBlock = {
            isOn in
            if isOn
            {
                self.weightTextView.hidden = false
                self.weightLabel.hidden = false
            }else{
                self.weightTextView.hidden = true
                self.weightLabel.hidden = true
            }
        }
        
    }
    
    @IBAction func backAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func makeRoundImage(imageView:UIImageView)
    {
        let maskPath = UIBezierPath.init(roundedRect: imageView.bounds, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSizeMake(7.0, 7.0))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = imageView.bounds;
        maskLayer.path = maskPath.CGPath
        imageView.layer.mask = maskLayer
        
    }
    
    
    @IBAction func btn_AddMusic_Click(sender: AnyObject) {
        btnIndex = sender.tag
        
//        let alertController = UIAlertController(title:nil, message:
//            nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//            // ...
//            
//        }
//        
//        let galleryAction = UIAlertAction(title: "Music Library", style: .Default) { (action) in
//            self.displayMediaPickerAndPlayItem()
//        }
//        
//        alertController.addAction(galleryAction)
//        alertController.addAction(cancelAction)
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnAdd_Click(sender: AnyObject) {
        
        btnIndex = sender.tag
//        
//        let alertController = UIAlertController(title: nil, message:
//            nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//            // ...
//        }
//        
//        let photoAction = UIAlertAction(title: "Camera Roll", style: .Default) { (action) in
//            // ...
//            self.takePhoto()
//        }
//        
//        let galleryAction = UIAlertAction(title: "Gallery", style: .Default) { (action) in
//            self.gallery()
//        }
//        
//        alertController.addAction(photoAction)
//        alertController.addAction(galleryAction)
//        alertController.addAction(cancelAction)
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
        let fusuma = FusumaViewController()
        
        //        fusumaCropImage = false
        
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(image: UIImage) {
        
        print("Image selected")
        let img = image
        loadingIndicators[btnIndex].startAnimating()
        loadingIndicators[btnIndex].hidden = false
        Net.uploadImage(img, index: btnIndex).onSuccess(callback: { (_) -> Void in
            Net.me().onSuccess(callback: {(user) -> Void in
                UserProfile.userProfile.user = user
                FBEvent.profileReceived(user)
                //refresh profile image
                if user.profileMainImage != nil
                {
                    UserProfile.saveMainPictureUrl(user.profileMainImage!)
                }
                self.configure()
                self.loadingIndicators[self.btnIndex].stopAnimating()
                self.loadingIndicators[self.btnIndex].hidden = true
            })
        }).onFailure(callback: { (_) -> Void in
            self.loadingIndicators[self.btnIndex].stopAnimating()
            self.loadingIndicators[self.btnIndex].hidden = true
        })

    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        print("video completed and output to file: \(fileURL)")
//        self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after dismissed FusumaViewController")
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
    }

    func addBtn_Click(btnIndex:Int)
    {
        
    }
    
//    func takePhoto()
//    {
//        let imagePicker = UIImagePickerController()
//        if(UIImagePickerController.isSourceTypeAvailable(.Camera)){
//            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear)==nil{
//                //                Alert.Warning(self,message: "Rear Camera doesn't exist Application can not access the camera")
//                
//            }else
//            {
//                imagePicker.sourceType = .Camera
//                imagePicker.allowsEditing=true
//                imagePicker.delegate=self
//                
//                presentViewController(imagePicker, animated: true, completion: {})
//                
//            }
//            
//        }else{
//            
//        }
//    }
    
//    func gallery()
//    {
//        let myPickerController = UIImagePickerController()
//        myPickerController.delegate = self;
//        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        myPickerController.allowsEditing = true
//        self.presentViewController(myPickerController, animated: true, completion: nil)
//        
//    }
    
    @IBOutlet weak var img2Loding: UIActivityIndicatorView!
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
//        
//        
//    {
//        //        let imageView:[UIImageView] = [image0, image1, image2]
//        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
//        loadingIndicators[btnIndex].startAnimating()
//        loadingIndicators[btnIndex].hidden = false
//        Net.uploadImage(img!, index: btnIndex).onSuccess(callback: { (_) -> Void in
//            Net.me().onSuccess(callback: {(user) -> Void in
//                UserProfile.userProfile.user = user
//                FBEvent.profileReceived(user)
//                //refresh profile image
//                if user.profileMainImage != nil
//                {
//                    UserProfile.saveMainPictureUrl(user.profileMainImage!)
//                }
//                self.configure()
//                self.loadingIndicators[self.btnIndex].stopAnimating()
//                self.loadingIndicators[self.btnIndex].hidden = true
//            })
//        }).onFailure(callback: { (_) -> Void in
//            self.loadingIndicators[self.btnIndex].stopAnimating()
//            self.loadingIndicators[self.btnIndex].hidden = true
//        })
//        
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        let name = textInputs[0].text
        let phoneNumber = textInputs[1].text
        let detail = textInputs[2].text
        let fly = flycheckBox.isOn() ? "1" : "0"
        let base = baseCheck.isOn() ? "1" : "0"
        let hand = handCheck.isOn() ? "1" : "0"
        let lbasing = lbaseCheck.isOn() ? "1" : "0"
        let whip = whipCheck.isOn() ? "1" : "0"
        let pop = popCheck.isOn() ? "1" : "0"
        let both = bothCheck.isOn() ? "1" : "0"
        let weight = weightTextView.text
        if let user = UserProfile.currentUser()
        {
            let params = [ AYNet.USERNAME: name as! AnyObject,
                       AYNet.USERFACEBOOKID: user.facebookid as! AnyObject,
                       AYNet.KEY_PHONENUMBER: phoneNumber as! AnyObject,
                       AYNet.KEY_DETAIL: detail as! AnyObject,
                       AYNet.KEY_FLY: fly as AnyObject,
                       AYNet.KEY_BASE: base as AnyObject,
                       AYNet.KEY_HAND: hand as AnyObject,
                       AYNet.KEY_LBASING: lbasing as AnyObject,
                       AYNet.KEY_WHIP: whip as AnyObject,
                       AYNet.KEY_POP: pop as AnyObject,
                       AYNet.KEY_BOTH: both as AnyObject,
                       AYNet.KEY_ACROTYPE: weight as! AnyObject,
                       AYNet.USERMAINIMAGEURL: user.profileMainImage as! AnyObject]
        MRProgressOverlayView.dismissOverlayForView(FBoxHelper.getWindow(), animated: true)
        Net.requestServer(AYNet.UPLOADPROFILE_URL, params: params).onSuccess(callback: { (enabled) -> Void in
            Net.me().onSuccess(callback: {(user) -> Void in
                UserProfile.userProfile.user = user
                //refresh profile image
                if user.profileMainImage != nil
                {
                    UserProfile.saveMainPictureUrl(user.profileMainImage!)
                }
                FBEvent.profileReceived(user)
            })
            MRProgressOverlayView.dismissOverlayForView(FBoxHelper.getWindow(), animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }).onFailure { (error) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            MRProgressOverlayView.dismissOverlayForView(FBoxHelper.getWindow(), animated: true)
        }
        
        }
    }
    
//    //** media libray
//    func displayMediaPickerAndPlayItem(){
//        
//        mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
//        
//        if let picker = mediaPicker{
//            
//            
//            print("Successfully instantiated a media picker")
//            picker.delegate = self
//            picker.allowsPickingMultipleItems = true
//            picker.showsCloudItems = true
//            picker.prompt = "Pick a song please..."
//            view.addSubview(picker.view)
//            
//            presentViewController(picker, animated: true, completion: nil)
//            
//        } else {
//            print("Could not instantiate a media picker")
//        }
//        
//    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
}
