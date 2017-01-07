//
//  CustomOverlayView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "overlay_like"
private let overlayLeftImageName = "overlay_skip"

class CustomOverlayView: UIView {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    
    var view:UIView!
    
    var nameEnglish: String? {
        didSet {
            if let nameEnglish = nameEnglish {
                label1.text = nameEnglish
            }
        }
    }
    
    var flagImage: UIImage? {
        didSet {
            if let flagImage = flagImage {
                myImage.image = flagImage
            }
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
        awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //setup()
        //self.parseClassName = "Countries"
        awakeFromNib()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true;
        
    }
    
    private func initialize() {
        
        addSubview(label1)
        addSubview(myImage)
    }
    
}
