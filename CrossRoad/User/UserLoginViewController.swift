//
//  UserLoginViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/23.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserLoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var selectedIndex: Int!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textField settings
		self.passwordTextField.secureTextEntry = true
		
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
	
    @IBAction func login(sender: AnyObject) {
        /*var config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 10
        var manager: Manager = Manager(configuration: config)
        
        manager.request(.POST, (user.objectForKey("siteURL") as! String) + (user.objectForKey("postPHPPath") as! String), parameters: para)
            .response { req, res, string, err in
                println("req: \(req)")
                println("res: \(res)")
                println("obj: \(string)")
                println("err: \(err)")
        }*/
        
		request(.POST, siteURL + "user.php", parameters: [
			"name": usernameTextField.text!,
			"password": passwordTextField.text!.sha1(),
			"flag": 1
			])
            .responseString { response in
				print(self.passwordTextField.text!.sha1())
				if response.result.value != nil {
					print(response.result.value!)
					if response.result.value == "0" {
						let alert = UIAlertView(title: "提示", message: "用户名或密码错误", delegate: nil, cancelButtonTitle: "好")
						alert.show()
					}
                    else {
                        request(.POST, siteURL + "user_info.php", parameters: ["uid": response.result.value!])
                            .responseJSON { repJSON in
								print(repJSON)
								
                                if repJSON.result.value != nil {
                                    let data = NSKeyedArchiver.archivedDataWithRootObject(repJSON.result.value!)
                                    
                                    //save user data in disk
                                    userData.setObject(response.result.value!, forKey: "UID")
                                    userData.setObject(data, forKey: "user_info")
                                    
                                    userData.synchronize()
                                    
                                    //send message to notification center, change the tabbarcontroller
                                    NSNotificationCenter.defaultCenter().postNotificationName("ChangeTab", object: nil, userInfo: ["index": self.selectedIndex])
									
                                    
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                                else {
                                    NetworkServices.noInternetConnection(self)
                                }
                        }
					}
				}
				else {
					print("hehe")
					NetworkServices.noInternetConnection(self)
				}
        }
    }
    
    @IBAction func loginGiveUp(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
    }
}