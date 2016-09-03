//
//  UserAddreditorViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/29.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class UserAddreditorViewController: UIViewController {
	
	@IBOutlet weak var receiverTextField: UITextField!
	@IBOutlet weak var telephoneTextField: UITextField!
	@IBOutlet weak var mailCodeTextField: UITextField!
	@IBOutlet weak var districtTextField: UITextField!
	@IBOutlet weak var addressTextView: UITextView!
	@IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = true
		
		self.confirmButton.warningStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	@IBAction func sendAddrInform(sender: AnyObject) {
		request(.POST, siteURL + "address.php", parameters: [
			"action": "add",
			"id": 1,
			"name": receiverTextField.text!,
			"tel": telephoneTextField.text!,
			"mailcode": mailCodeTextField.text!,
			"addr": addressTextView.text!])
			.responseString { response in
				if response.result.value! == "1" {
					LogicServices.popAlertController("提示", message: "修改成功", vc: self, if_timer: true)
				}
				else {
					let alert: UIAlertController = UIAlertController(title: "提示", message: "保存失败", preferredStyle: UIAlertControllerStyle.Alert)
					let alertBtn: UIAlertAction = UIAlertAction(title: "好", style: UIAlertActionStyle.Cancel, handler: nil)
					alert.addAction(alertBtn)
					
					self.presentViewController(alert, animated: true, completion: nil)
				}
		}
	}
}