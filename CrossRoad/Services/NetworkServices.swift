//
//  NetworkServices.swift
//  o2o
//
//  Created by 张海阳 on 15/5/28.
//  Copyright (c) 2015年 张海阳. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class NetworkServices {
    
    class func synchronousGet(site: String, phpPath: String, option: String) -> JSON {
        var json: JSON!
        
        //创建NSURL对象
        let url:NSURL! = NSURL(string: site + phpPath + "?" + option)
        
        //创建请求对象
        let urlRequest : NSURLRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10)
        
        //响应对象
        var response:NSURLResponse?
        
        //错误对象
        var error:NSError?
        
        //发出请求
        var data:NSData?
        do {
            data = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
        } catch let error1 as NSError {
            error = error1
            data = nil
        }
        
        if (error != nil) {
            print(error?.code)
            print(error?.description)
        }
        else {
            json = JSON(data: data!)
        }
        
        return json
    }
    
    class func synchronousPost(name: String, mailAdd: String, password: String, flag: Int) -> Int {
        var json: JSON!
        var result: String?
        
        //创建NSURL对象
        let url:NSURL! = NSURL(string: siteURL + getPHPPath)
        
        //创建请求对象
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10)
        
        request.HTTPMethod = "POST"//设置请求方式为POST，默认为GET
        
        let str:String = "name=" + name + "&mail=" + mailAdd + "&passwd=" + password + "&flag=" + flag.description;//设置参数
        let data:NSData = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.HTTPBody = data;
        
        //响应对象
        var response:NSURLResponse?
        
        //错误对象
        var error:NSError?
        
        //发出请求
        var received:NSData?
        do {
            received = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        } catch let error1 as NSError {
            error = error1
            received = nil
        }
        
        if (error != nil)
        {
            print(error?.code)
            print(error?.description)
        }
        else {
            result = NSString(data: received!, encoding: NSUTF8StringEncoding) as? String
            print(result)
        }
        
        return 0
    }
	
	class func noInternetConnection(vc: UIViewController) {
		let alert: UIAlertController = UIAlertController(title: "提示", message: "请检查您的网络连接", preferredStyle: UIAlertControllerStyle.Alert)
		let action: UIAlertAction = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler: nil)
		alert.addAction(action)
		vc.presentViewController(alert, animated: true, completion: nil)
	}
}