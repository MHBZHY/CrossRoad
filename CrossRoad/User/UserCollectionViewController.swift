//
//  UserCollectionViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/26.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class UserCollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleSegmentedControl: UISegmentedControl!
    
    var jsonData: JSON = JSON("")
    let collection = [
        "mall", "store"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.hidesBottomBarWhenPushed = true
        
		//maintableview settings
		self.mainTableView.delegate = self
		self.mainTableView.dataSource = self
        
        //load data
        self.refresh(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let hehe = UIAlertController(title: "hehe", message: "hehe", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(hehe, animated: true, completion: nil)
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "collectionToFloor" {
			let dest = segue.destinationViewController as! MallFloorViewController
			dest._mall_id = sender as? Int
		}
	}
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return jsonData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("reuse")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuse")
        }
		
		cell!.imageView!.sd_setImageWithURL(NSURL(string: jsonData[indexPath.section][indexPath.row]["imgpath"].stringValue as String))
		cell!.imageView!.layer.cornerRadius = cell!.imageView!.frame.height / 2
        cell!.textLabel!.text = jsonData[indexPath.section][indexPath.row]["title"].stringValue as String
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("collectionToFloor", sender: indexPath.row)
	}
    
    func refresh(index: Int) {
        let para = [
            "action": self.collection[index],
            "UID": userData.objectForKey("UID") as! String
        ]
        
        request(.POST, siteURL + "getcollection.php", parameters: para)
            .responseJSON { response in
                if response.result.value != nil {
                    self.jsonData = JSON(response.result.value!)
                    
                    let data = NSKeyedArchiver.archivedDataWithRootObject(response.result.value!)
                    
                    userData.setObject(NSKeyedUnarchiver.unarchiveObjectWithData(data)!, forKey: "mall_collection")
                    userData.synchronize()
                }
                else {
					if userData.objectForKey("mall_collection") != nil {
						self.jsonData = JSON(userData.objectForKey("mall_collection")!)
						self.mainTableView.reloadData()
					}
					
                    NetworkServices.noInternetConnection(self)
                }
        }
    }
    
    @IBAction func didValueChanged(sender: AnyObject) {
		self.refresh((sender as! UISegmentedControl).selectedSegmentIndex)
    }
	
}