//
//  UserSettingsViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/21.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import WebImage

class UserSettingsViewContrller: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleSegmentedControl: UISegmentedControl!
    
    var _type: Int!
    var _cellData: [[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		//init data
		self.titleSegmentedControl.selectedSegmentIndex = -_type
		self.didValueChanged(self.titleSegmentedControl)
		
//		self.hidesBottomBarWhenPushed = true
		
        //self.usersysSegmented.addTarget(self, action: "didSegmentedValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
	
	override func viewDidLayoutSubviews() {
		self.mainTableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return _cellData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cellData[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("reuse")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuse")
        }
        cell!.textLabel!.text = _cellData[indexPath.section][indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
        switch self.titleSegmentedControl.selectedSegmentIndex {
        case 0:
            if indexPath.section == 1 {		//user log out
                let alertView: UIAlertController = UIAlertController(title: "提示", message: "您确定要注销吗？", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction: UIAlertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { action in
                    userData.removeObjectForKey("UID")
					userData.removeObjectForKey("user_info")
					userData.synchronize()
					
					UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
					self.tabBarController!.selectedIndex = 1
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
                
                alertView.addAction(okAction)
                alertView.addAction(cancelAction)
                
                self.presentViewController(alertView, animated: true, completion: nil)
            }
			else {
				self.performSegueWithIdentifier("usersettingsToEdit", sender: nil)
			}
        case 1:
            if indexPath.section == 1 {
				//clear image cache
				SDImageCache.sharedImageCache().clearDisk()
				SDImageCache.sharedImageCache().clearMemory()
				
				let alert: UIAlertController = UIAlertController(title: "提示", message: "清除成功", preferredStyle: UIAlertControllerStyle.Alert)
				let action: UIAlertAction = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(action)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        default:
            print("hehe")
        }
    }
    
//    func dataAccordingToType(type: Int) {
//        switch type {
//        case -1:
//            self.titleSegmentedControl.selectedSegmentIndex = 1
//            
//            _cellData = [
//                ["检查更新"],
//                ["清除缓存"]
//            ]
//        case 0:
//            _cellData = [
//                ["上传头像", "用户名", "性别", "生日"],
//                ["注销"]
//            ]
//        default:
//            break
//        }
//    }
	
    @IBAction func didValueChanged(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            _cellData = [
                ["用户信息修改"],
                ["注销"]
            ]
        case 1:
            _cellData = [
				["检查更新"],
				["清除缓存"],
                ["联系我们"]
            ]
        default:
            _cellData = nil
        }
        
        self.mainTableView.reloadData()
    }
    
}