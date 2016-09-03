//
//  AlipayService.swift
//  eMall-quick
//
//  Created by zhy on 15/8/21.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Product {
	var name: String
	var description: String
	var price: Float
}

public class AlipayService {
	
	class func createOrder(parameters: [String: AnyObject], product: Product) {
		
		let partner: String = ""
		let seller: String = ""
		let privateKey: String = ""
		
		request(.POST, siteURL + postPHPPath, parameters: parameters)
			.responseString { response in
				
				//instantiate order
				let order = Order()
				
				order.partner = partner
				order.seller = seller
				order.productName = product.name
				//order.tradeNO = self.generateTradeNO()
				order.productDescription = product.description
				order.amount = product.price.description
				//order.notifyURL = ""
				order.service = "mobile.securitypay.pay"
				order.paymentType = "1"
				order.inputCharset = "utf-8"
				order.itBPay = "30m"
				
				//regist app scheme
				let appScheme: String = "mallinhome"
				
				//product info
				let orderSpec: String = order.description()
				print("orderSpec=\(orderSpec)")
				
				//get private key and sign, according RSA and base64
				let signer: DataSigner = CreateRSADataSigner(privateKey)
				let signedString: String? = signer.signString(orderSpec)
				
				//convert signer string to order string
				var orderString: String?
				
				if signedString != nil {
					orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"" + "RSA" + "\""
					
					
					AlipaySDK.defaultService().payOrder(orderString!, fromScheme: appScheme, callback: { (NSDictionary resultDic) in
						print("result = \(resultDic)")
					})
				}
		}
	}
}

public class Order {
	var partner: String?
	var seller: String?
	var tradeNO: String?
	var productName: String?
	var productDescription: String?
	var amount: String?
	var notifyURL: String?
	
	var service: String?
	var paymentType: String?
	var inputCharset: String?
	var itBPay: String?
	var showURL: String?
	
	var extraParams = Dictionary<String, String>()
	
	func description() -> String {
		var description: String = ""
		
		if self.partner != nil {
			description += "partner=\"\(self.partner!)\""
		}
		
		if self.seller != nil {
			description += "&seller_id=\"\(self.seller!)\""
		}
		
		if self.tradeNO != nil {
			description += "&out_trade_no=\"\(self.tradeNO!)\""
		}
		
		if self.productName != nil {
			description += "&subject=\"\(self.productName!)\""
		}
		
		if self.productDescription != nil {
			description += "&body=\"\(self.productDescription!)\""
		}
		
		if self.amount != nil {
			description += "&total_fee=\"\(self.amount!)\""
		}
		
		if self.notifyURL != nil {
			description += "&notify_url=\"\(self.notifyURL!)\""
		}
		
		if self.service != nil {
			description += "&service=\"\(self.service!)\""
		}
		
		if self.paymentType != nil {
			description += "&payment_type=\"\(self.paymentType!)\""
		}
		
		if self.inputCharset != nil {
			description += "&_input_charset=\"\(self.inputCharset!)\""
		}
		
		if self.itBPay != nil {
			description += "&it_b_pay=\"\(self.itBPay!)\""
		}
		
		if self.showURL != nil {
			description += "&show_url=\"\(self.showURL!)\""
		}
		
		for key in self.extraParams.keys {
			description += "&\(key)=\"\(self.extraParams[key])\""
		}
		
		return description
	}
}
