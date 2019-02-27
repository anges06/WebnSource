//
//  DataExchange.swift
//  WebnSource
//
//  Created by anges on 16.02.19.
//  Copyright © 2019 anges. All rights reserved.
//

import Foundation
import UIKit



class DataExchange: UITabBarController {
    var Url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor(red: 0.0, green: 0.59, blue: 1.0, alpha: 1.0)
        self.tabBar.barTintColor = UIColor(red: 0.226, green: 0.226, blue: 0.226, alpha: 1.0)
        self.tabBar.unselectedItemTintColor = UIColor.white
        
    }
}
