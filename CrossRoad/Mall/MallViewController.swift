//
//  MallViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/12.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	@IBOutlet weak var mainTableView: UITableView!
	@IBOutlet weak var sidebarView: UIView!
    @IBOutlet weak var sidebarIndexButton: UIButton!
    @IBOutlet weak var sidebarSearchButton: UIButton!
    @IBOutlet weak var movableView: UIView!
	
    @IBOutlet weak var sideButtonTopDistance: NSLayoutConstraint!
    
	var _jsonData = JSON("1")
    var _district: Int = 1      //1: default haidian
    var searchString: String?
	var _sideBarFlag: Int = 0		//0: reduce, 1: expand
    var _sideBarButtonFlag: Int = 0		//0: index, 1: search
    var _tabbarHeight: CGFloat!
	var outsideTableView: UITableView!
    var searchBar: UISearchBar!
	
	let sidebarText: [String] = [
		"海淀区",
		"东城区",
		"西城区",
		"朝阳区",
		"石景山区",
		"丰台区",
		"顺义区",
		"怀柔",
        "密云",
        "延庆",
        "昌平区",
        "平谷",
        "门头沟区",
        "房山",
        "通州"
	]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        //backbarbutton text
        let backButton: UIBarButtonItem = UIBarButtonItem()
        backButton.title = "返回"
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()       //white back button
		
		//maintableview settings
		self.mainTableView.delegate = self
		self.mainTableView.dataSource = self
		
		//add tap recognizer to hide keyboard
		let tapRecg = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
		tapRecg.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tapRecg)
		
    }
	
    override func viewDidLayoutSubviews() {
		//searchbar settings
		self.searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width * 0.88, 40))
		self.searchBar.delegate = self
		self.view.addSubview(self.searchBar)
		
		//outsideTableView settings
		self.outsideTableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width * 0.88, self.view.frame.height), style: UITableViewStyle.Plain)
		self.outsideTableView.tag = 101
        
		
		
		_tabbarHeight = self.tabBarController!.tabBar.frame.height
		self.outsideTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: _tabbarHeight, right: 0)
		self.outsideTableView.backgroundColor = UIColor.blackColor()
		self.outsideTableView.showsVerticalScrollIndicator = false
		
		self.outsideTableView.delegate = self
		self.outsideTableView.dataSource = self
		
		self.view.addSubview(self.outsideTableView)
		self.view.bringSubviewToFront(self.outsideTableView)	//bring outsideTableView front of searchBar
		
		//hide outsidetableview
		self.view.bringSubviewToFront(self.movableView)
		
		//get initialize data
		self.refresh(0)
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "mallToFloor" {
			let dest = segue.destinationViewController as! MallFloorViewController
			dest._mall_id = sender as! Int
		}
        
        //hidesBottomBarWhenPushed
        (segue.destinationViewController).hidesBottomBarWhenPushed = true
	}
	
    //UITableView delegate and datasource meyhods
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if tableView.tag == 0 {
			return self._jsonData.count
		}
		else {
			return 1
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView.tag == 0 {
			return 1
		}
		else {
            if _sideBarButtonFlag == 0 {
                return self.sidebarText.count
            }
            else {
				return _jsonData.count
            }
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if tableView.tag == 0 {
			let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("mall")!
			
			LogicServices.setImageView(cell.contentView.viewWithTag(1) as! UIImageView, imageURLStr: imgPath + _jsonData[indexPath.section]["imgpath"].stringValue)
            (cell.contentView.viewWithTag(2) as! UILabel).text = _jsonData[indexPath.section]["title"].stringValue
			
			cell.tag = self._jsonData[indexPath.section]["id"].intValue
			
			return cell
		}
		else {
			if _sideBarButtonFlag == 0 {
				var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("district")
				
				if cell == nil {
					cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "district")
				}
				
                cell!.textLabel!.text = self.sidebarText[indexPath.row]
                cell!.backgroundColor = UIColor.blackColor()
                cell!.tintColor = UIColor.whiteColor()
                cell!.textLabel!.textColor = UIColor.whiteColor()
				
				return cell!
            }
            else {
				var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("search")
				
				if cell == nil {
					cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "search")
				}
				
				cell!.textLabel!.text = _jsonData[indexPath.row]["name"].stringValue
				cell!.backgroundColor = UIColor.blackColor()
				cell!.tintColor = UIColor.whiteColor()
				cell!.textLabel!.textColor = UIColor.whiteColor()
				
				return cell!
            }
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if tableView.tag == 0 {
			self.performSegueWithIdentifier("mallToFloor", sender: tableView.cellForRowAtIndexPath(indexPath)!.tag)
		}
		else {
			if _sideBarButtonFlag == 0 {
				_district = indexPath.row + 1
				
				self.refresh(0)
				
				self.sidebarReduceAnimation()
			}
			else {
				self.performSegueWithIdentifier("mallToFloor", sender: _jsonData[indexPath.row]["id"].intValue)
			}
		}
			
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
    
    //UISearchBar delegate method
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        print("Editing Start!")
        return true
    }
	
    //get search result immediately
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		print("text changed!")
        request(.GET, siteURL + "searchMall.php", parameters: ["name": searchText])
			.responseJSON { response in
				if response.result.value != nil {
					print(response.result.value!)
					self._jsonData = JSON(response.result.value!)
					self.outsideTableView.reloadData()
				}
				else {
					NetworkServices.noInternetConnection(self)
				}
		}
    }
	
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        request(.GET, siteURL + "searchMall.php", parameters: ["mall": self.searchBar.text!])
            .responseString { response in
                if response.result.value != nil {
                    self.searchString = response.result.value!
                    self.outsideTableView.reloadData()
                }
                else {
                    NetworkServices.noInternetConnection(self)
                }
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("Editing End!")
    }
    
    func sidebarExpandAnimation() {
        _sideBarFlag = 1
        
		UIView.animateWithDuration(0.3, animations: {
			self.movableView.frame.origin = CGPointMake(self.view.frame.width * 0.88, 0)
		})
	}
	
    func sidebarReduceAnimation() {
        _sideBarFlag = 0
		
		UIView.animateWithDuration(0.3, animations: {
            self.movableView.frame.origin = CGPointMake(0, 0)
		})
	}
	
	@IBAction func indexClicked(sender: AnyObject) {
		if _sideBarFlag == 0 {
			self.sidebarExpandAnimation()
			
			if _sideBarButtonFlag == 1 {
				_sideBarButtonFlag = 0      //change button flag to index
				self.changeToIndex()        //detail realization
			}
		}
		else {
			if _sideBarButtonFlag == 0 {
				self.sidebarReduceAnimation()
			}
			else {
				_sideBarButtonFlag = 0      //change button flag to index
				self.changeToIndex()        //detail realization
			}
		}
	}
    
    //detail realization
    func changeToIndex() {
		self.outsideTableView.frame = CGRectMake(0, 0, self.view.frame.width * 0.88, self.view.frame.height)
        self.outsideTableView.reloadData()
    }
	
	@IBAction func searchClicked(sender: AnyObject) {
		if _sideBarFlag == 0 {
			self.sidebarExpandAnimation()
			
			if _sideBarButtonFlag == 0 {
				_sideBarButtonFlag = 1
				self.changeToSearch()
			}
		}
		else {
			if _sideBarButtonFlag == 0 {
				_sideBarButtonFlag = 1
				self.changeToSearch()
			}
			else {
				self.sidebarReduceAnimation()
			}
		}
	}
    
    //detail realization
	func changeToSearch() {
		_jsonData = JSON("")
		self.outsideTableView.frame = CGRectMake(0, 40, self.view.frame.width * 0.88, self.view.frame.height - 40)
		self.outsideTableView.reloadData()
    }
	
	func hideKeyboard(tap: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
	
	@IBAction func refresh(sender: AnyObject) {
        request(.GET, siteURL + "mall_info.php", parameters: ["district": _district.description])
            .responseJSON { response in
				print(response)
                if response.result.value != nil {
                    self._jsonData = JSON(response.result.value!)
                    
                    let label: UILabel = UILabel(frame: CGRectZero)
                    label.backgroundColor = UIColor ( red: 0.1333, green: 0.1333, blue: 0.1333, alpha: 1.0 )
                    label.textColor = UIColor.whiteColor()
                    label.textAlignment = NSTextAlignment.Center
                    label.text = self.sidebarText[self._district - 1]
                    label.sizeToFit()
                    
                    self.navigationItem.titleView = label
                    self.mainTableView.reloadData()
                }
                else {
                    NetworkServices.noInternetConnection(self)
                }
        }
    }
    
    @IBAction func addToCollection(sender: AnyObject) {
        request(.GET, siteURL + "collection.php", parameters: [
            "action": "mall",
            "id": (sender.superview!!.superview as! UITableViewCell).tag,
            "uid": userData.objectForKey("UID") as! String],
			encoding: ParameterEncoding.URL)
            .responseString { response in
                if response.result.value != nil {
                    if response.result.value == "0" {
                        print("错误")
                    }
                    
                    //change the collection button's back color
                    if sender.backgroundImageForState(UIControlState.Normal) == UIImage(named: "collection") {
                        sender.setBackgroundImage(UIImage(named: "collection_selected"), forState: UIControlState.Normal)
                    }
                    else {
                        sender.setBackgroundImage(UIImage(named: "collection"), forState: UIControlState.Normal)
                    }
                    
                    //pop successful window
                    let alert: UIAlertController = UIAlertController(title: "提示", message: "收藏成功", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    NetworkServices.noInternetConnection(self)
                }
        }
		
		
    }
	
	
}
