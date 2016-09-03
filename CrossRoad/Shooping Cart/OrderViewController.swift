//
//  OrderViewController.swift
//  CrossRoad
//
//  Created by qyxt on 15/9/18.
//  Copyright (c) 2015年 QiYangXinTian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var naviSegmentedControl: UISegmentedControl!
    
    var _jsonData = JSON("")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //mainTableView settings
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        request(.GET, siteURL + "order.php", parameters: ["UID": userData.objectForKey("UID") as! String, "type": self.naviSegmentedControl.selectedSegmentIndex])
            .responseJSON {response in
                if response.2.value != nil {
                    self._jsonData = JSON(response.2.value!)
                    self.mainTableView.reloadData()
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _jsonData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = self.mainTableView.dequeueReusableCellWithIdentifier("order")!
        
        return cell
    }
}
