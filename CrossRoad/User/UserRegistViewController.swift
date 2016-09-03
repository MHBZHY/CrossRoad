//
//  UserRegistViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/23.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class UserRegistViewController: UIViewController {
    
    var result: Int!
	var mailOrTelFlag: Int = 0		//0: mail, 1: tel
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwdConfirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.passwordTextField.secureTextEntry = true
		self.passwdConfirmTextField.secureTextEntry = true
		
		//add tap recognizer to hide keyboard
		let tapRecg = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
		tapRecg.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tapRecg)
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func hideKeyboard(tap: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
	
    @IBAction func postData(sender: AnyObject) {
        
        if nameTextField.text == "" || mailTextField.text == "" || passwordTextField.text == "" || passwdConfirmTextField == "" {
            let alert = UIAlertView(title: "提示", message: "请键入完整信息", delegate: nil, cancelButtonTitle: "好")
            
            alert.show()
        }
        else if passwordTextField.text != passwdConfirmTextField.text {
            let alert = UIAlertView(title: "提示", message: "两次密码不符", delegate: nil, cancelButtonTitle: "好")
            
            alert.show()
        }
        else {
			for ch in self.mailTextField.text!.characters {
				if ch == "@" {
					request(.POST, siteURL + "mail/register.php", parameters: [
						"name": nameTextField.text!,
						"password": passwordTextField.text!.sha1(),
						"mail": mailTextField.text!
						])
						.responseString { response in
							if response.result.value == "1" {
								let alert = UIAlertView(title: "提示", message: "提交成功，一封激活邮件已发送到您的邮箱中，请转到邮箱中继续操作", delegate: nil, cancelButtonTitle: "好")
								
								alert.show()
								self.dismissViewControllerAnimated(true, completion: {
									self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
								})
							}
							else if response.result.value == "0" {
								let alert = UIAlertView(title: "提示", message: "注册失败", delegate: nil, cancelButtonTitle: "好")
								
								alert.show()
							}
							else {
								let alert = UIAlertView(title: "提示", message: "呵呵", delegate: nil, cancelButtonTitle: "好")
								
								alert.show()
							}
					}
				}
			}
        }
    }
    /*
    func authentication(result: Int) {
        self.result = result
    }
    */
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}