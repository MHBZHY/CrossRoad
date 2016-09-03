//
//  UserOrderViewController.swift
//  CrossRoad
//
//  Created by zhy on 10/1/15.
//  Copyright © 2015 张海阳. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var naviSegementedControl: UISegmentedControl!
	@IBOutlet weak var mainTableView: UITableView!

	var _segmentedIndex: Int!
	var _jsonData = JSON("")
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.mainTableView.delegate = self
		self.mainTableView.dataSource = self
		
		//get initialize data
		self.refresh(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _jsonData.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("order")!
		
		(cell.contentView.viewWithTag(101) as! UIImageView).sd_setImageWithURL(NSURL(string: _jsonData[indexPath.row]["imgpath"].stringValue), placeholderImage: UIImage(named: "placeholder.png")!)
		(cell.contentView.viewWithTag(102) as! UILabel).text = _jsonData[indexPath.row]["title"].stringValue
		(cell.contentView.viewWithTag(103) as! UILabel).text = _jsonData[indexPath.row]["description"].stringValue
		(cell.contentView.viewWithTag(104) as! UILabel).text = _jsonData[indexPath.row]["price"].stringValue
		
		return cell
	}

	@IBAction func refresh(sender: AnyObject) {
		request(.GET, siteURL + "getorder.php", parameters: [
			"uid": userData.objectForKey("UID") as! String,
			"kind": self.naviSegementedControl.selectedSegmentIndex
			])
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
	
	@IBAction func kindsChanged(sender: AnyObject) {
		self.refresh(0)
	}
}
