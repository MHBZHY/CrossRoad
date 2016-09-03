//
//  SearchViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/30.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var barSearchTextField: UITextField!
    @IBOutlet weak var mainTableView: UITableView!
	@IBOutlet weak var naviSegmentedControl: UISegmentedControl!
    
    var _jsonData: JSON = JSON("")
	var _segmentIndex: Int?		//number of page decided by other views
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        //mainTableView settings
		self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
		self.barSearchTextField.delegate = self
        
        //add tap recognizer to hide keyboard
        let tapRecg = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        tapRecg.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecg)
		
		//initialize data
		if _segmentIndex != nil {
			self.naviSegmentedControl.selectedSegmentIndex = _segmentIndex!
		}
        
		
		self.segmentedAction(self.naviSegmentedControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "searchToGoods" {
			let dest = segue.destinationViewController as! GoodsViewController
			dest._commodity_id = sender as! Int
		}
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _jsonData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.mainTableView.dequeueReusableCellWithIdentifier("goods")!
        
        (cell.contentView.viewWithTag(101) as! UIImageView).sd_setImageWithURL(NSURL(string: _jsonData[indexPath.row]["imgpath"].stringValue), placeholderImage: UIImage(named: "placeholder.png"))
        (cell.contentView.viewWithTag(101) as! UIImageView).layer.cornerRadius = (cell.viewWithTag(101) as! UIImageView).frame.height / 2
		(cell.contentView.viewWithTag(102) as! UILabel).text = _jsonData[indexPath.row]["title"].stringValue
		(cell.contentView.viewWithTag(103) as! UILabel).text = _jsonData[indexPath.row]["description"].stringValue
		
		return cell
    }
	
    func hideKeyboard(tap: UITapGestureRecognizer) {
        self.barSearchTextField.resignFirstResponder()
    }
    
	//tableview rows action
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("searchToGoods", sender: _jsonData[indexPath.row]["id"].intValue)
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	//response for return key, to execute search action
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		//refresh data
//        request(.GET, siteURL + "search.php", parameters: ["name": self.barSearchTextField.text]
		
        request(.GET, siteURL + "search.php", parameters: ["name": self.barSearchTextField.text!])
            .responseJSON { response in
                if response.result.value != nil {
                    self._jsonData = JSON(response.result.value!)
                    self.mainTableView.reloadData()
                }
                else {
                    NetworkServices.noInternetConnection(self)
                }
        }
        
		//close keyboard
		textField.resignFirstResponder()
		
		return true
	}
	/*
	//show activityIndicator when reload data
	func refresh(parameters: [String: AnyObject]) {
		request(.GET, siteURL + "classify.php", parameters: parameters)
			.responseJSON { req, _, json, _ in
                println(req)
                println(json)
                
				if json != nil {
					self.jsonData = JSON(json!)
                    self.mainTableView.reloadData()
				}
				else {
					NetworkServices.noInternetConnection(self)
				}
		}
	}
	*/
    @IBAction func segmentedAction(sender: AnyObject) {
        request(.GET, siteURL + "classify.php", parameters: ["kind": (sender as! UISegmentedControl).selectedSegmentIndex + 1])
            .responseJSON { response in
				print(response.request)
                if response.result.value != nil {
                    self._jsonData = JSON(response.result.value!)
                    self.mainTableView.reloadData()
                }
                else {
                    NetworkServices.noInternetConnection(self)
                }
        }
    }
    
    @IBAction func sendWhenEditing(sender: AnyObject) {
        request(.GET, siteURL + "search.php", parameters: ["name": self.barSearchTextField.text!])
            .responseJSON { response in
				print(response.request)
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