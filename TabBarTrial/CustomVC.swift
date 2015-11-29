//
//  CustomVC.swift
//  TabBarTrial
//
//  Created by orkenstein on 27.11.15.
//  Copyright © 2015 orkenstein. All rights reserved.
//

import UIKit

class CustomVC: UIViewController {

  convenience init(title: String) {
    self.init()
    self.title = title
    
    self.view.backgroundColor = UIColor(hue: CGFloat(random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 0.5, alpha: 1.0)
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  }

}
