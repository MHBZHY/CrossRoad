//
//  UserBillsViewController.swift
//  eMall-quick
//
//  Created by zhy on 15/7/26.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import UIKit

class UserBillsViewController: UIViewController {
    
    var billsSegmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billsSegmentedController = UISegmentedControl(items: ["待付款", "待发货", "待收货", "待评价", "售后服务"])
        billsSegmentedController.frame = CGRectMake(self.view.frame.width * 0.05, 64, self.view.frame.width * 0.9, 30)
        billsSegmentedController.selectedSegmentIndex = 0
        billsSegmentedController.addTarget(self, action: "segmentedCtrlDidValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(billsSegmentedController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func segmentedCtrlDidValueChanged() {
        
    }
}