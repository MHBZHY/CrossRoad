//
//  ShoppingCartViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/8/3.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ShoppingCartViewController: UIViewController, UITableViewDataSource {
	
	@IBOutlet weak var mainTableView: UITableView!
	
	var jsonData: JSON!
	var alert: UIAlertController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.refresh(0)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    
	func timeUp() {
		self.alert.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = mainTableView.dequeueReusableCellWithIdentifier("spCart")!
		
		(cell.viewWithTag(0) as! UIImageView).image = UIImage(data: NSData(contentsOfURL: NSURL(string: jsonData[indexPath.row]["img"].stringValue as String)!)!)
		(cell.viewWithTag(1) as! UILabel).text = jsonData[indexPath.row]["title"].stringValue as String
		(cell.viewWithTag(2) as! UILabel).text = jsonData[indexPath.row]["detail"].stringValue as String
		(cell.viewWithTag(3) as! UILabel).text = jsonData[indexPath.row]["price"].stringValue as String
		
		return cell
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return jsonData.count
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("spCartToGoods", sender: NSURL(string: self.jsonData[indexPath.row]["url"].stringValue as String))
	}
	
	@IBAction func refresh(sender: AnyObject) {
		request(.POST, siteURL + "getshoppingcart.php", parameters: [
			"UID": userData.objectForKey("UID") as! String,
			"action": "spCart"
			])
			.responseJSON { response in
				if response.result.value == nil {
					NetworkServices.noInternetConnection(self)
				}
				else {
					self.jsonData = JSON(response.result.value!)
					self.mainTableView.reloadData()
					
					userData.setObject(response.result.value, forKey: "spCartData")
					
					userData.synchronize()
				}
		}
	}
}