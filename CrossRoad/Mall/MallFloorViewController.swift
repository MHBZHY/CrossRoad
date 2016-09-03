//
//  MallFloorViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/8/16.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MallFloorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var mainTableView: UITableView!
	
	//segue data
	var _mall_id: Int!
	
    //tableview datasource
	var _jsonData = JSON("")
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
        //backbarbutton text
        let backButton: UIBarButtonItem = UIBarButtonItem()
        backButton.title = "返回"
        self.navigationItem.backBarButtonItem = backButton
		
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        
        self.refresh(0)
	}
	
    override func viewDidAppear(animated: Bool) {
		//add effectview to label in cell
		if _jsonData != JSON("") {
			for i in 0...1 {
				let cell = self.mainTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: i))
				
				let effectView1: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
				effectView1.alpha = 0.4
				effectView1.frame = cell!.viewWithTag(1)!.frame
				effectView1.layer.cornerRadius = 5
				effectView1.clipsToBounds = true
				
				let effectView2: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
				effectView2.alpha = 0.4
				effectView2.frame = cell!.viewWithTag(3)!.frame
				effectView2.layer.cornerRadius = 5
				effectView2.clipsToBounds = true
				
				cell!.contentView.addSubview(effectView1)
				cell!.contentView.addSubview(effectView2)
				cell!.contentView.bringSubviewToFront(cell!.viewWithTag(1)!)
				cell!.contentView.bringSubviewToFront(cell!.viewWithTag(3)!)
			}
		}
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "floorToList" {
			let dest = segue.destinationViewController as! StoreListViewController
            dest._mall_id = _mall_id
            dest._floor = sender as! Int + 1
		}
	}
	
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 19
    }
    
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self._jsonData.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = self.mainTableView.dequeueReusableCellWithIdentifier("floor")!
		
		//cell settings
		(cell.contentView.viewWithTag(1) as! UILabel).text = indexPath.section.description + "F"
        print("img: " + self._jsonData[indexPath.section]["imgpath"].stringValue)
        (cell.contentView.viewWithTag(1) as! UILabel).numberOfLines = 0
        (cell.contentView.viewWithTag(1) as! UILabel).sizeToFit()
		(cell.contentView.viewWithTag(2) as! UIImageView).sd_setImageWithURL(NSURL(string: imgPath + self._jsonData[indexPath.section]["imgpath"].stringValue), placeholderImage: UIImage(named: "placeholder.png"))
		(cell.contentView.viewWithTag(3) as! UILabel).text = self._jsonData[indexPath.section]["description"].stringValue
        (cell.contentView.viewWithTag(3) as! UILabel).numberOfLines = 0
        (cell.contentView.viewWithTag(3) as! UILabel).sizeToFit()
        
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("floorToList", sender: indexPath.section)
	}
	
	@IBAction func refresh(sender: AnyObject) {
		request(.GET, siteURL + "mall_floor.php", parameters: ["mall": _mall_id])
			.responseJSON { response in
				print(response.result.value)
				if response.result.value != nil {
					self._jsonData = JSON(response.result.value!)
					self.mainTableView.reloadData()
				}
				else {
					NetworkServices.noInternetConnection(self)
				}
		}
    }
}
