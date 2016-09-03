//
//  MainTabBarController.swift
//  CrossRoad
//
//  Created by zhy on 15/8/25.
//  Copyright (c) 2015年 QiYangXinTian. All rights reserved.
//

import UIKit

protocol ChangeTab {
    func changeTab(index: Int)
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    var storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        self.selectedIndex = 1
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeTab:", name: "ChangeTab", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if userData.objectForKey("UID") == nil {
            
            switch viewController.tabBarItem.title! {
                
            case "购物车":
                let loginView = storyBoard.instantiateViewControllerWithIdentifier("loginView") as! UserLoginViewController
                tabBarController.presentViewController(loginView, animated: true, completion: nil)
                loginView.selectedIndex = 2
                
                return false
                
            case "用户":
                let loginView = storyBoard.instantiateViewControllerWithIdentifier("loginView") as! UserLoginViewController
                tabBarController.presentViewController(loginView, animated: true, completion: nil)
                loginView.selectedIndex = 3
                
                return false
                
            default:
                return true
            }
        }
        else {
            return true
        }
    }
    
    func changeTab(notification: NSNotification) {
        self.selectedIndex = (notification.userInfo as! NSDictionary)["index"] as! Int
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
