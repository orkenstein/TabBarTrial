//
//  TabVC.swift
//  TabBarTrial
//
//  Created by orkenstein on 27.11.15.
//  Copyright © 2015 orkenstein. All rights reserved.
//

import UIKit

class TabVC: UITabBarController {
  
  let kSplitTabCount = 4
  let kNavTabCount = 2
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var newVCArray: [UIViewController] = []
    
    for index in 1...kSplitTabCount {
      let splitVC = UISplitViewController()
      splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
      let masterVC = UINavigationController(rootViewController: CustomVC(title: "\(index)"))
      splitVC.viewControllers.append(masterVC)
      let detailVC = UINavigationController(rootViewController: index != 2 ? CustomVC(title: "\(index)") : GeoVC(title: "\(index)"))
      splitVC.viewControllers.append(detailVC)
      
      splitVC.tabBarItem.title = "\(index)"
      newVCArray.append(splitVC)
    }
    for index in kSplitTabCount+1...kSplitTabCount+kNavTabCount {
      let navVC = UINavigationController(rootViewController: CustomVC(title: "\(index)"))
      
      navVC.tabBarItem.title = "\(index)"
      newVCArray.append(navVC)
    }
    
    viewControllers = newVCArray
    customizableViewControllers = nil
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    hiJackMoreTab()
  }
  
  func hiJackMoreTab() {
    moreNavigationController.navigationBar.topItem?.title = "ИСЧО"
    moreNavigationController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    // Good ole' subview hunting!
    guard let tabBarButtonClass = NSClassFromString("UITabBarButton") else {
      return
    }
    
    let subviews = tabBar.subviews.filter { (view) -> Bool in
      return view.isMemberOfClass(tabBarButtonClass)
    }
    guard let moreTabBarButton = subviews.last else {
      return
    }
    
    guard let tabBarButtonLabelClass = NSClassFromString("UITabBarButtonLabel") else {
      return
    }
    
    let labels = moreTabBarButton.subviews.filter { (view) -> Bool in
      return view.isMemberOfClass(tabBarButtonLabelClass)
    }
    
    guard let label = labels.first as? UILabel else {
      return
    }
    
    //  Finally!!111!!!
    label.text = "ИСЧО"
  }

}
