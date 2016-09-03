//
//  DataServices.swift
//  o2o
//
//  Created by 张海阳 on 15/5/31.
//  Copyright (c) 2015年 张海阳. All rights reserved.
//

import CoreLocation
import UIKit
import SwiftyJSON
import Alamofire

protocol UIViewPassValueDelegate {
	func passValue(value: String)
}

public class LogicServices {
	
    /*
    //use for get malls' location
    class func getNearMallList(URL: String, currentLocation: CLLocation, accuracy: Int) -> Array<Mall> {
        
        var jsonNSArray: NSArray = NetworkServices.synchronousGet(URL, option: "shop")
        var mall: Mall
        var mallListArray: Array<Mall> = Array()
        
        for i in 0...jsonNSArray.count - 1 {
            mall = self.jsonAnalyseMall(jsonNSArray, dictPositionIndex: i)
            
            if currentLocation.distanceFromLocation(mall.getMallLocation()).hashValue < accuracy {
                mallListArray.append(mall)
            }
        }
        
        return mallListArray		//location list
    }
    
    //use for search dictionary
    class func jsonAnalyse(jsonNSArray: NSArray, dictPositionIndex: Int, valueOfObject: String) -> NSDictionary {
        
        var dict = jsonNSArray.objectAtIndex(dictPositionIndex) as! NSDictionary
        
        //compare to database, the key should be changed as the case
        switch valueOfObject {
            
        case dict.objectForKey("filename") as! String:
            return dict
        case dict.objectForKey("id") as! String:
            return dict
        case dict.objectForKey("mod") as! String:
            return dict
        case dict.objectForKey("date") as! String:
            return dict
            
        default:
            return NSDictionary()
        }
    }
    
    class func jsonAnalyse(jsonNSArray: NSArray, dictPositionIndex: Int, keyOfObject: String) -> String {
        var dict = jsonNSArray.objectAtIndex(dictPositionIndex) as! NSDictionary
        return dict.objectForKey(keyOfObject) as! String
    }
    
    //use for analyse malls' location
    class func jsonAnalyseMall(jsonNSArray: NSArray, dictPositionIndex: Int) -> Mall {
        
        var dict = jsonNSArray.objectAtIndex(dictPositionIndex) as! NSDictionary
        var location: CLLocation = CLLocation(latitude: dict.objectForKey("latitude") as! Double, longitude: dict.objectForKey("longitude") as! Double)
        
        return Mall(name: dict.objectForKey("name") as! String, location: location)
    }
    
    //get needed image
    class func getImageFromServer(jsonArray: NSArray, site: String, valueOfID: String) -> UIImage {
        var urlStr = site + jsonAnalyse(jsonArray, keyOfObjectToSearch: "id", valueOfObjectToSearch: valueOfID, keyOfObjectToGet: "imagepath")
        
        let url: NSURL = NSURL(string: urlStr)!
        var data: NSData = NSData(contentsOfURL: url)!
        
        return UIImage(data: data)!
    }
    
    class func getImageFromServer(jsonArray: NSArray, site: String, valueOfMall: String) -> UIImage {
        var urlStr = site + jsonAnalyse(jsonArray, keyOfObjectToSearch: "mall", valueOfObjectToSearch: valueOfMall, keyOfObjectToGet: "imagepath")
        
        let url: NSURL = NSURL(string: urlStr)!
        var data: NSData = NSData(contentsOfURL: url)!
        
        return UIImage(data: data)!
    }
    
    class func getImageFromServer(jsonArray: NSArray, site: String, valueOfStore: String) -> UIImage {
        var urlStr = site + jsonAnalyse(jsonArray, keyOfObjectToSearch: "store", valueOfObjectToSearch: valueOfStore, keyOfObjectToGet: "imagepath")
        
        let url: NSURL = NSURL(string: urlStr)!
        var data: NSData = NSData(contentsOfURL: url)!
        
        return UIImage(data: data)!
    }
    
    //return only one string, follow pacific options
    class func jsonAnalyse(jsonNSArray: NSArray, keyOfObjectToSearch: String, valueOfObjectToSearch: String, keyOfObjectToGet: String) -> String {
        for i in 0...jsonNSArray.count - 1 {
            var dict = jsonNSArray.objectAtIndex(i) as! NSDictionary
            
            if dict.objectForKey(keyOfObjectToSearch) as! String == valueOfObjectToSearch {
                if dict.objectForKey(keyOfObjectToGet) != nil {
                    return dict.objectForKey(keyOfObjectToGet) as! String
                }
            }
        }
        
        return String()
    }
    */
    
    class func getShopDataForStoreListVC() -> Array<shopData> {
        let json: JSON = NetworkServices.synchronousGet(siteURL, phpPath: "", option: "shop")
        var shopArray: Array<shopData> = Array()
        
        print(json.count)
        
        for var i = 0; i < json.count; i++ {
            var shop: shopData = shopData(shopNameLabel: "", shopIntroductionTextView: "", webview: NSURL())
            
            shop.shopNameLabel = jsonAnalyse(json, keyOfObject: "shop_name", indexOfArray: i) as! String
            shop.shopIntroductionTextView = jsonAnalyse(json, keyOfObject: "shop_content", indexOfArray: i) as! String
            shop.webview = NSURL(string: jsonAnalyse(json, keyOfObject: "shop_url", indexOfArray: i) as! String)!
            
            shopArray.append(shop)
        }
        
        return shopArray
    }
    
    class func jsonAnalyse(json: JSON, keyOfObject: String, indexOfArray: Int) -> AnyObject {
        return json[indexOfArray][keyOfObject].stringValue
    }
    
    class func getImageFromServer(path: String) -> UIImage {
        let url: NSURL = NSURL(string: path)!
        let data: NSData = NSData(contentsOfURL: url)!
        
        return UIImage(data: data)!
    }
    
	class func createHomeButton(frame: CGRect, title: String?, imageName: String, radius: Bool) -> UIButton {
		let button = UIButton(frame: frame)
		
		if title != nil {
			button.setTitle(title, forState: UIControlState.Normal)
		}
		button.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.opaque = true
        button.adjustsImageWhenHighlighted = true
		if radius {
			button.layer.cornerRadius = button.frame.height / 2
			button.clipsToBounds = true
		}
		
        return button
    }
    
    class func createUserButtons(frame: CGRect, title: String) -> UIButton {
        let button: UIButton = UIButton(frame: frame)
        
        button.setTitle(title, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.opaque = true
        button.adjustsImageWhenHighlighted = true
        
        return button
    }
	
//    class func refresh(vc: UIViewController, specificPath: String, inout jsonData: JSON, para: [String: AnyObject], tableview: UITableView) {
//		request(.GET, siteURL + specificPath, parameters: para)
//			.responseJSON { response in
//				if response.result.value != nil {
//					jsonData = JSON(response.result.value!)
//					tableview.reloadData()
//				}
//				else {
//					NetworkServices.noInternetConnection(vc)
//				}
//		}
//	}
	
	class func popAlertController(title: String, message: String, vc: UIViewController, if_timer: Bool) {
		let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		vc.presentViewController(alert, animated: true, completion: nil)
		
		if if_timer == true {
			let timer: NSTimer = NSTimer(timeInterval: 1, target: self, selector: "dismissAlertController:", userInfo: alert, repeats: false)
			timer.fire()
		}
	}
	
	func dismissAlertController(timer: NSTimer) {
		(timer.userInfo as! UIAlertController).dismissViewControllerAnimated(true, completion: {
			timer.invalidate()
		})
	}
	
	class func addTapRecognizerToHomeImageView(cell: UITableViewCell, commodity_id: [Int]) {
		for i in 0...3 {
			let tap = UITapGestureRecognizer(target: HomeViewController(), action: "tapImage:")
			cell.contentView.viewWithTag(103 + i)!.addGestureRecognizer(tap)
			cell.contentView.viewWithTag(103 + i)!.userInteractionEnabled = true
			
		}
	}
	
	class func setImageView(imageView: UIImageView, imageURLStr: String) {
		imageView.sd_setImageWithURL(NSURL(string: imageURLStr), placeholderImage: UIImage(named: "placeholder.png"))
		imageView.contentMode = UIViewContentMode.ScaleAspectFill
		imageView.clipsToBounds = true
	}
}

