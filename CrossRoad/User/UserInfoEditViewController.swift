//
//  UserInfoEditViewController.swift
//  CrossRoad
//
//  Created by zhy on 10/6/15.
//  Copyright © 2015 张海阳. All rights reserved.
//

import UIKit

class UserInfoEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var mainTableView: UITableView!

	var _cellData: [String] = ["上传头像", "用户名", "性别", "生日"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.mainTableView.delegate = self
		self.mainTableView.dataSource = self
		self.mainTableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
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
		return _cellData.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 114
		}
		else {
			return 53
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("face")!
			
			(cell.contentView.viewWithTag(101) as! UILabel).text = "上传头像"
			(cell.contentView.viewWithTag(101) as! UILabel).sizeToFit()
			
			let imageView = cell.contentView.viewWithTag(102) as! UIImageView
			
			imageView.sd_setImageWithURL(NSURL(string: imgPath + (userData.objectForKey("UID") as! String)))
			imageView.layer.cornerRadius = imageView.frame.height / 2
			imageView.clipsToBounds = true
			
			return cell
		}
		else {
			let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("edit")!
			
			(cell.contentView.viewWithTag(101) as! UILabel).text = _cellData[indexPath.row - 1]
			(cell.contentView.viewWithTag(101) as! UILabel).sizeToFit()
			
			return cell
		}
	}
//	
//	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//		return nil
//	}
}
