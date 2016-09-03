//
//  UserAddrmgrViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/26.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class UserAddrmgrViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
	@IBOutlet weak var addAddrButton: UIButton!
    
    var _jsonData = JSON("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.mainTableView.delegate = self
		self.mainTableView.dataSource = self
		
		self.mainTableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
		
		//init data
		self.refresh(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "addrmgrToEditor" {
			if sender != nil {
				
			}
		}
	}
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return _jsonData.count
		}
		else {
			return 1
		}
    }
	
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("address")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "address")
        }
        cell!.textLabel!.text = _jsonData[indexPath.row]["receiver"].stringValue
		cell!.detailTextLabel!.text = _jsonData[indexPath.row]["address"].stringValue
        cell!.selectionStyle = UITableViewCellSelectionStyle.Gray
		if indexPath.section == 0 {
			cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		}
		
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("addrmgrToEditor", sender: indexPath.row)
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
	
	@IBAction func refresh(sender: AnyObject) {
		request(.POST, siteURL + "address.php", parameters: ["uid": userData.objectForKey("UID") as! String])
			.responseJSON { response in
				if response.result.value != nil {
					self._jsonData = JSON(response.result.value!)
					self.mainTableView.reloadData()
				}
				else {
					NetworkServices.noInternetConnection(self)
				}
		}
	}
	
	@IBAction func addAddress(sender: AnyObject) {
		self.performSegueWithIdentifier("addrmgrToEditor", sender: nil)
	}
}