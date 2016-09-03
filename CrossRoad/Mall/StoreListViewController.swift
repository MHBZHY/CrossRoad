//
//  StoreListViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/12.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class StoreListViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pictureScrollView: UIScrollView!
    @IBOutlet weak var introductionTextView: UITextView!
    var webView: UIWebView!
    var sideStoreListTableView: UITableView!
    var pageCtrl: UIPageControl!
    
    var _jsonData: JSON = JSON("")
    var _mall_id: Int!
    var _floor: Int!
    var _pageNumber: Int!
    var _presentURLRequest: NSURLRequest = NSURLRequest()
	var _isLink = false
    var _sideIsShow = 0     //0: hide, 1: show
	
	//segue data
	var section: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //backbarbutton text
        let backButton: UIBarButtonItem = UIBarButtonItem()
        backButton.title = "返回"
        self.navigationItem.backBarButtonItem = backButton
        
        //mainScrollView settings
        self.mainScrollView.showsHorizontalScrollIndicator = false
        self.mainScrollView.backgroundColor = UIColor ( red: 0.898, green: 0.9098, blue: 0.9333, alpha: 1.0 )
        self.mainScrollView.delegate = self
        self.mainScrollView.tag = 0
		
		//storeListTableView settings
		
        //pictureScrollView settings
        self.pictureScrollView.showsVerticalScrollIndicator = false
        self.pictureScrollView.showsHorizontalScrollIndicator = false
        self.pictureScrollView.delegate = self
        self.pictureScrollView.tag = 1
        
        //get data
        //println("mall: \(_mall_id), floor: \(_floor)")
        request(.GET, siteURL + "getstore.php", parameters: ["mall": _mall_id, "floor": _floor])
            .responseJSON { response in
                if response.result.value != nil {
                    self._jsonData = JSON(response.result.value!)
					
					//update sideStoreListTableView's data
					self.sideStoreListTableView.reloadData()
                    
                    //introductionTextView settings
                    self.introductionTextView.text = self._jsonData[0]["title"].stringValue
                    
                    //add sub imageViews in pictureScrollView
                    if self._jsonData.count != 0 {
                        for i in 0...(self._jsonData.count - 1) {
                            let imageView: UIImageView = UIImageView(frame: CGRectMake(CGFloat(i) * self.pictureScrollView.frame.width, 0, self.pictureScrollView.frame.width, self.pictureScrollView.frame.height))
                            imageView.sd_setImageWithURL(NSURL(string: imgPath + self._jsonData[i]["imgpath"].stringValue), placeholderImage: UIImage(named: "placeholder.png"))
                            self.pictureScrollView.addSubview(imageView)
                        }
                    }
                    
                    //pageCtrl settings
                    self.pageCtrl = UIPageControl(frame: CGRectMake(0, self.pictureScrollView.frame.height * 0.8, self.pictureScrollView.frame.width, 40))
                    self.pageCtrl.tintColor = UIColor.whiteColor()
                    self.pageCtrl.currentPage = 0
                    self.pageCtrl.numberOfPages = self._jsonData.count
                    self.pageCtrl.userInteractionEnabled = false
                    self.mainScrollView.addSubview(self.pageCtrl)
                    
                    //webView settings
                    self.webView = UIWebView(frame: CGRectMake(0, self.mainScrollView.frame.height, self.mainScrollView.frame.width, self.mainScrollView.frame.height))
                    self.mainScrollView.addSubview(self.webView)
                    
                    self._presentURLRequest = NSURLRequest(URL: NSURL(string: self._jsonData[0]["url"].stringValue)!)
                }
                else {
                    NetworkServices.noInternetConnection(self)
                }
        }
    }
    
    override func viewDidLayoutSubviews() {
        //sideStoreListTableView settings
        self.sideStoreListTableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), style: UITableViewStyle.Plain)
        self.sideStoreListTableView.backgroundColor = UIColor.blackColor()
        self.sideStoreListTableView.delegate = self
        self.sideStoreListTableView.dataSource = self
        
        self.view.addSubview(sideStoreListTableView)
        self.view.bringSubviewToFront(self.mainScrollView)
    }
    
    override func viewDidAppear(animated: Bool) {
        //mainScrollView settings
        self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.width, self.mainScrollView.frame.height * 2)
        
        //pictureScrollView settings
        self.pictureScrollView.contentSize = CGSizeMake(self.pictureScrollView.frame.width * CGFloat(_jsonData.count), self.pictureScrollView.frame.height)
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "storeListToSpecific" {
			let dest = segue.destinationViewController as! WebViewController
			dest._request = sender as! NSMutableURLRequest
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        _pageNumber = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        if scrollView.tag == 1 {
            self.updateData()
            
            //change pageCtrl
            self.pageCtrl.currentPage = _pageNumber
            
            _isLink = false
        }
        else if scrollView.tag == 0 {
            if scrollView.contentOffset.y / scrollView.frame.height == 1 {
                self.webView.loadRequest(_presentURLRequest)
            }
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url: NSURL = request.URL!
        
        if !_isLink {
            _isLink = true
            return true
        }
        else {
            self.performSegueWithIdentifier("storeListToWebView", sender: NSMutableURLRequest(URL: url))
            
            return false
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _jsonData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = self.sideStoreListTableView.dequeueReusableCellWithIdentifier("store")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "store")
        }
        
        cell!.textLabel!.text = _jsonData[indexPath.row]["title"].stringValue
        cell!.backgroundColor = UIColor.blackColor()
        cell!.tintColor = UIColor.whiteColor()
        cell!.textLabel!.textColor = UIColor.whiteColor()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _pageNumber = indexPath.row
        self.pictureScrollView.contentOffset.x = self.pictureScrollView.frame.width * CGFloat(_pageNumber)
        self.updateData()
        self.hideStoreList()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func updateData() {
        self.introductionTextView.text = _jsonData[_pageNumber]["title"].stringValue
        _presentURLRequest = NSURLRequest(URL: NSURL(string: _jsonData[_pageNumber]["url"].stringValue)!)
    }
    
    func showStoreList() {
        UIView.animateWithDuration(0.3, animations: {
            self.mainScrollView.frame.origin = CGPointMake(-self.mainScrollView.frame.width, 0)
        })
        
        print("Expanded")
    }
    
    func hideStoreList() {
        UIView.animateWithDuration(0.3, animations: {
            self.mainScrollView.frame.origin = CGPointMake(0, 0)
        })
        
        print("Hiden")
    }
    
    @IBAction func sideStoreList(sender: AnyObject) {
        if _sideIsShow == 0 {
            self.showStoreList()
            _sideIsShow = 1
        }
        else if _sideIsShow == 1 {
            self.hideStoreList()
            _sideIsShow = 0
        }
    }
}
