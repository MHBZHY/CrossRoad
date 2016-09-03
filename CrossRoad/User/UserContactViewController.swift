//
//  UserContactViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/26.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class UserContactViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var submitTextView: UITextView!
    
    var user = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.hidesBottomBarWhenPushed = true
		
        self.submitTextView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
			request(.POST, siteURL + "contact.php", parameters: ["uid": userData.objectForKey("UID") as! String, "text": submitTextView.text])
                .responseString { response in
					if response.result.value != nil {
						if response.result.value! == "1" {
							LogicServices.popAlertController("提示", message: "您的反馈我们已收到，感谢您的支持", vc: self, if_timer: true)
						}
					}
					else {
						NetworkServices.noInternetConnection(self)
					}
            }
					
            return false
        }
        
        return true
    }
}