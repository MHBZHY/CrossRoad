//
//  WebViewController.swift
//  CrossRoad
//
//  Created by zhy on 15/8/25.
//  Copyright (c) 2015年 QiYangXinTian. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var mainWebView: UIWebView!
    var _request: NSMutableURLRequest!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.mainWebView.loadRequest(_request)
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

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let good_id = request.URL
        
        self.performSegueWithIdentifier("webViewToGoods", sender: good_id)
        
        return false
    }
}
