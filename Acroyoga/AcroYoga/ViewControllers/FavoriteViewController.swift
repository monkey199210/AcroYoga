//
//  FavoriteViewController.swift
//  TurnUP
//
//  Created by SCAR on 3/21/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.addSlideMenuButton()
        self.initRippleEffect()
        
    }
    
    func initRippleEffect()
    {

    }
}
