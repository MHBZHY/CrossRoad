//
//  UserViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/6/26.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var settingsButton: UIButton!

    var mainTableView: UITableView!
    var titleImage: UIImageView!
    var userSettingsView: UIView!
    var userImage: UIImageView!
    var userLabel: UILabel!
    var _cellsData: [[String]] = [
        ["地址管理", "address"],
        ["优惠", "discount", "我的收藏", "collection"],
        ["联系我们", "contact"]
    ]
    
    var i = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //backbarbutton text
        let backButton: UIBarButtonItem = UIBarButtonItem()
        backButton.title = "返回"
        self.navigationItem.backBarButtonItem = backButton
        
        //setting button
        settingsButton.tag = -1
        
        //mainTableView settings
        self.mainTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.Grouped)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        
        //orderInformView settings
//        self.orderInformView = UIView(frame: CGRectMake(0, -40, self.view.frame.width, 40))
//        self.orderInformView.backgroundColor = UIColor.whiteColor()
//        
//        self.mainTableView.addSubview(self.orderInformView)
//        
        //background image
        titleImage = UIImageView(frame: CGRect(x: 0, y: -self.view.frame.width * 0.4, width: self.view.frame.width, height: self.view.frame.width * 0.4))
        titleImage.image = UIImage(named: "image3")
        titleImage.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.mainTableView.addSubview(titleImage)
        
        //show user inform and lead to user settings
        userSettingsView = UIView(frame: CGRectMake(0, -titleImage.frame.height + 74, self.view.frame.width, titleImage.frame.height - 74))
        userSettingsView.userInteractionEnabled = true
		
		//add blur effect to usersettingsview
		let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
		effectView.frame = userSettingsView.frame
		effectView.alpha = 1
		
		self.mainTableView.addSubview(effectView)
		
		//user image
        userImage = UIImageView(frame: CGRectMake(userSettingsView.frame.width * 0.05, userSettingsView.frame.height * 0.125, userSettingsView.frame.height * 0.75, userSettingsView.frame.height * 0.75))
        userImage.layer.cornerRadius = userImage.frame.height / CGFloat(2)
        userImage.clipsToBounds = true
        userSettingsView.addSubview(userImage)
		
		//user name
        userLabel = UILabel(frame: CGRectMake(userImage.frame.origin.x + userImage.frame.width + self.view.frame.width * 0.05, (userSettingsView.frame.height - 20) * 0.5, self.view.frame.width * 0.15, 20))
        userLabel.text = "您尚未登录"
		userLabel.sizeToFit()
        userLabel.textColor = UIColor.blackColor()
        userSettingsView.addSubview(userLabel)
        
        self.mainTableView.addSubview(userSettingsView)
        
        //add event to userSettingsView
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "userSettingsAction:")
        userSettingsView.addGestureRecognizer(tap)
        
        //give space to image
        self.mainTableView.contentInset = UIEdgeInsetsMake(-64 + titleImage.frame.height + 80, 0, 0, 0)
        
        self.view.addSubview(self.mainTableView)
		
		//get user data
		var jsonData = JSON(NSKeyedUnarchiver.unarchiveObjectWithData(userData.objectForKey("user_info") as! NSData)!)
		
		userImage.sd_setImageWithURL(NSURL(string: jsonData[0]["imgpath"].stringValue))
		userLabel.text = jsonData[0]["username"].stringValue
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = true
		self.clearBackView(self.navigationController!.navigationBar)
		UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
		print(JSON(NSKeyedUnarchiver.unarchiveObjectWithData(userData.objectForKey("user_info") as! NSData)!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //make the user navigation bar clear
    func clearBackView(superView: UIView) {
        if superView.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!) {
            for view in superView.subviews {
                if view.isKindOfClass(UIImageView) {
//                    view.removeFromSuperview()
					view.hidden = true
                }
            }
            
            let navBackView: UIView = superView
            navBackView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0)
        }
        else if superView.isKindOfClass(NSClassFromString("_UIBackdropView")!) {
            superView.hidden = true
        }
        
        for view in superView.subviews {
            self.clearBackView(view)
        }
    }
	
	func fixBackView(superView: UIView) {
		if superView.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!) {
			for view in superView.subviews {
				if view.isKindOfClass(UIImageView) {
					view.hidden = false
				}
			}
			
			let navBackView: UIView = superView
			navBackView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0)
		}
		else if superView.isKindOfClass(NSClassFromString("_UIBackdropView")!) {
			superView.hidden = false
		}
		
		for view in superView.subviews {
			self.clearBackView(view)
		}
	}
	
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        
        if y < -self.view.frame.width * 0.4 {
            var frame: CGRect = titleImage.frame
            
            frame.origin.y = y
            frame.size.height = -y
            titleImage.frame = frame
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
//        else if section == 1 {
//            return 2
//        }
//        else {
//            return 1
//        }
		switch section {
		case 0:
			return 1
		case 1:
			return 1
		case 2:
			return 2
		case 3:
			return 1
			
		default:
			return 1
		}
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell1Height: CGFloat = 50
		let imageHeight: CGFloat = cell1Height - 25
		let cell1 = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "order")
		cell1.frame.size = CGSizeMake(tableView.frame.width, cell1Height)
		
		//orderButtons
		let buttonLable = ["全部订单", "待付款", "待发货", "待收货"]
		let buttonImage = ["orders", "paying", "sending", "receiving"]
		
		for i in 0...3 {
			let x = CGFloat(i + 1) * (cell1.frame.width - imageHeight * 4) / 5 + CGFloat(i) * imageHeight
			var labelWidth: CGFloat!
			if i == 0 {
				labelWidth = 48
			}
			else {
				labelWidth = 36
			}
			let labelHeight: CGFloat = 12
			
			let button = LogicServices.createUserButtons(CGRectMake(x, 5, imageHeight, imageHeight), title: "")
			button.setBackgroundImage(UIImage(named: buttonImage[i]), forState: UIControlState.Normal)
			button.tag = i;
			button.addTarget(self, action: "showOrderInform:", forControlEvents: UIControlEvents.TouchUpInside)
			
			let label = UILabel(frame: CGRectMake(x + (button.frame.width - labelWidth) / 2, button.frame.origin.y + imageHeight + (cell1Height - button.frame.origin.y - imageHeight - labelHeight) / 2, labelWidth, labelHeight))
			label.text = buttonLable[i]
			label.font = label.font.fontWithSize(12)
			
			cell1.contentView.addSubview(button)
			cell1.contentView.addSubview(label)
		}
		
		if indexPath.section == 0 {
			return cell1
		}
		
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("userCell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "userCell")
        }
		
        cell!.textLabel?.text = _cellsData[indexPath.section - 1][((indexPath.row + 1)  * 2) - 2]
        cell!.imageView?.image = UIImage(named: _cellsData[indexPath.section - 1][((indexPath.row + 1)  * 2) - 1] + ".png")
        cell!.selectionStyle = UITableViewCellSelectionStyle.Gray
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell!.tag = i
        i++
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        userSettingsAction(indexPath)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
	
	func showOrderInform(sender: UIButton) {
		print(sender.tag)
		self.performSegueWithIdentifier("userToOrder", sender: sender.tag)
	}
	
    func userSettingsAction(sender: AnyObject) {
        if !(sender is NSIndexPath) {
            self.performSegueWithIdentifier("pushToUserSettings", sender: sender)
        }
        else {
            switch (sender as! NSIndexPath).section {
            case 1:
                self.performSegueWithIdentifier("pushToAddrmgr", sender: nil)
            case 2:
                switch (sender as! NSIndexPath).row {
                case 0:
                    self.performSegueWithIdentifier("pushToDiscount", sender: nil)
                case 1:
                    self.performSegueWithIdentifier("pushToCollection", sender: nil)
                default:
                    break
                }
            case 3:
                self.performSegueWithIdentifier("pushToContact", sender: nil)
            default:
                break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushToUserSettings" {
            let dest = segue.destinationViewController as! UserSettingsViewContrller
            
            if sender is UITableViewCell {
                dest._type = (sender as! UITableViewCell).tag
            }
            else if sender is UIButton {
                dest._type = (sender as! UIButton).tag
            }
            else {
                dest._type = 0
            }
        }
		else if segue.identifier == "userToOrder" {
			let dest = segue.destinationViewController as! UserOrderViewController
			
			dest._segmentedIndex = sender as! Int
		}
        //hidesBottomBarWhenPushed
		(segue.destinationViewController).hidesBottomBarWhenPushed = true
		self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
		UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
}

