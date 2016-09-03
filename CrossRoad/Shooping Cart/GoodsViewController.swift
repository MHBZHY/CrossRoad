//
//  GoodsViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/8/17.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GoodsViewController: UIViewController, UIScrollViewDelegate {
	@IBOutlet weak var carouselScrollView: UIScrollView!
	@IBOutlet weak var detailView: UIView!
	@IBOutlet weak var settingsWebView: UIWebView!
	
	var pageCtrl: UIPageControl!
	
	//segue data
	var _commodity_id: Int!
    
    var _jsonData = JSON("")
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let label: UILabel    = UILabel(frame: CGRectZero)
        label.backgroundColor = UIColor ( red: 0.1333, green: 0.1333, blue: 0.1333, alpha: 1.0 )
        label.text            = "商品信息"
        label.textColor       = UIColor.whiteColor()
        label.textAlignment   = NSTextAlignment.Center
        label.sizeToFit()
        
        self.navigationItem.titleView = label
		self.carouselScrollView.delegate = self
		
		//add taprecognizer to detail view
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "commodityDetail:")
		self.detailView.addGestureRecognizer(tap)
		
		//forbid webview to scroll
		self.settingsWebView.scrollView.bounces = false
		
		//get initialize data
		self.refresh(0)
		
		//load request to show commodity settings
		self.settingsWebView.loadRequest(NSURLRequest(URL: NSURL(string: _jsonData["url"].stringValue)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "buyNow" {
			let dest = segue.destinationViewController as! AlipayViewController
			let request = NSMutableURLRequest(URL: NSURL(string: siteURL + "Alipay.html")!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 20)
			
			request.HTTPMethod = "POST"
			request.HTTPBody = "id=\(_commodity_id)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
			
			dest._request = request
		}
		else if segue.identifier == "goodsToWebView" {
			let dest = segue.destinationViewController as! WebViewController
			let request = NSMutableURLRequest(URL: NSURL(string: siteURL + "showCommodity.php")!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 20)
			
			request.HTTPMethod = "GET"
			request.HTTPBody = "id=\(_commodity_id)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
			
			dest._request = request
		}
	}
	
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		//获取scrollView视图滚动的x坐标
		let offX:CGFloat = scrollView.contentOffset.x
		
		//计算当前是第几屏
		let index:Int = (Int)(offX / scrollView.frame.width)
		
		//设置分页指示器currentPage值
		pageCtrl.currentPage = index;
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	func commodityDetail(tap: UITapGestureRecognizer) {
		self.performSegueWithIdentifier("goodsToWebView", sender: _commodity_id)
	}
	
	@IBAction func addToShoppingCart(sender: AnyObject) {
		request(.GET, siteURL + "setshoppingcart.php", parameters: [
			"action": "commodity",
			"id": self._commodity_id,
			"uid": userData.objectForKey("UID") as! String
			])
			.responseString { response in
				if response.result.value != nil {
					if response.result.value == "0" {
						LogicServices.popAlertController("警告", message: "收藏失败", vc: self, if_timer: true)
					}
					else if response.result.value == "1" {
						LogicServices.popAlertController("提示", message: "收藏成功", vc: self, if_timer: true)
					}
				}
				else {
					NetworkServices.noInternetConnection(self)
				}
		}
	}
	
	@IBAction func collectStore(sender: AnyObject) {
		request(.GET, siteURL + "collection.php", parameters: ["action": "commodity", "id": _commodity_id, "UID": userData.objectForKey("UID") as! String])
			.responseString { response in
				if response.result.value != nil {
					if response.result.value! == "1" {
						LogicServices.popAlertController("提示", message: "收藏成功", vc: self, if_timer: true)
					}
					else {
						LogicServices.popAlertController("警告", message: "收藏失败，存在可能的服务器问题", vc: self, if_timer: true)
					}
				}
				else {
					NetworkServices.noInternetConnection(self)
				}
		}
	}
	
	@IBAction func buyNow(sender: AnyObject) {
		self.performSegueWithIdentifier("goodsToWebView", sender: _commodity_id)
	}
	
    @IBAction func refresh(sender: AnyObject) {
        request(.GET, siteURL + "getcommodity.php", parameters: ["id": _commodity_id])
            .responseJSON { response in
                if response.result.value != nil {
                    self._jsonData = JSON(response.result.value!)
					
					//generate commodity's images
                    for i in 0...(self._jsonData.count) {
                        let imageView: UIImageView = UIImageView(frame: CGRectMake(CGFloat(i) * self.carouselScrollView.frame.width, 0, self.carouselScrollView.frame.width, self.carouselScrollView.frame.height))
                        imageView.sd_setImageWithURL(NSURL(string: imgPath + self._jsonData[i]["imgpath"].stringValue), placeholderImage: UIImage(named: "placeholder.png"))
						print(imgPath + self._jsonData[i]["imgpath"].stringValue)
                        
                        self.carouselScrollView.addSubview(imageView)
                    }
                }
                else {
                    NetworkServices.noInternetConnection(self)
                }
        }
    }
}
