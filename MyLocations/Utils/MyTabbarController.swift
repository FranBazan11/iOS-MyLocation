//
//  MyTabbarController.swift
//  MyLocations
//
//  Created by francisco bazan on 4/1/20.
//  Copyright © 2020 Lagash Systems. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}

