//
//  UserDiscountViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/27.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class UserDiscountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mainTableView: UITableView!
    var cellData: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.hidesBottomBarWhenPushed = true
        
        //maintableview settings
        mainTableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain)
        mainTableView.delegate = self
        
        let indicate: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicate.center = self.view.center
        indicate.startAnimating()
        self.view.addSubview(indicate)
        
        request(.GET, siteURL + "getdiscount.php", parameters: ["uid": userData.objectForKey("UID") as! String])
            .responseString { response in
                self.cellData = JSON(response.result.value!)
                self.mainTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("reuse")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuse")
        }
        cell!.textLabel!.text = cellData[indexPath.row][0].stringValue as String
        cell?.detailTextLabel?.text = cellData[indexPath.row][1].stringValue as String
        cell?.imageView?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: cellData[indexPath.row][2].stringValue as String)!)!)
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("discountToSpecific", sender: self.cellData[indexPath.row][3].stringValue as String)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var dest = segue.destinationViewController as! SpecificInfoViewController
        
    }
}