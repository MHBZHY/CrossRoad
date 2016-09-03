//
//  SpecificInfoViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/18.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SpecificInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var mainTableView: UITableView!
    
    //var webView: UIWebView!
    //var buttonTag: Int?
    var URL: NSURL?
    var indicator: UIActivityIndicatorView!
	var action: String!
	var jsonData = JSON("")
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		request(.GET, siteURL + getPHPPath, parameters: ["home_tapSender": action])
			.responseJSON { response in
				if response.result.value != nil {
					self.jsonData = JSON(response.result.value!)
				}
				else {
					NetworkServices.noInternetConnection(self)
				}
		}
		
		if URL != nil {
			request(.GET, URL!)
				.responseJSON { response in
					if response.result.value != nil {
						self.jsonData = JSON(response.result.value!)
						self.mainTableView.reloadData()
					}
					else {
						NetworkServices.noInternetConnection(self)
					}
			}
		}
		
		self.mainTableView.delegate = self
		self.mainTableView.dataSource = self
		
        /*
        //var json: JSON = NetworkServices.synchronousGet(globalVariable.getSiteURL(), phpPath: globalVariable.getActionPHPPath(), option: "home_button")
        
        webView = UIWebView(frame: self.view.frame)
        webView.delegate = self
        
        /*if buttonTag != nil {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: LogicServices.jsonAnalyse(json, keyOfObject: "url", indexOfArray: buttonTag!) as! String)!))
            
        }
        else {*/
            webView.loadRequest(NSURLRequest(URL: url!))
        //}
		
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true*/
        
        //self.view.addSubview(webView)
        //self.view.addSubview(indicator)
    }
	
	override func viewDidLayoutSubviews() {
		self.mainTableView.frame = self.view.frame
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "storeToGoods" {
			let dest = segue.destinationViewController as! GoodsViewController
			dest._commodity_id = sender as! Int
		}
	}
	
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return jsonData.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("specific")!
		
		(cell.viewWithTag(0) as! UILabel).text = indexPath.section.description + "F"
		(cell.viewWithTag(1) as! UIImageView).sd_setImageWithURL(NSURL(string: self.jsonData[indexPath.section]["imgpath"].stringValue as String))
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("storeToGoods", sender: indexPath.section)
	}
	
    /*
    func webViewDidStartLoad(webView: UIWebView) {
        indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        indicator.stopAnimating()
    }
	*/
}