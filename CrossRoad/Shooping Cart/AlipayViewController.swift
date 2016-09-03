//
//  AlipayViewController.swift
//  CrossRoad
//
//  Created by qyxt on 15/9/17.
//  Copyright (c) 2015年 QiYangXinTian. All rights reserved.
//

import UIKit

class AlipayViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var mainWebView: UIWebView!
    
    var _request: NSMutableURLRequest!
    let _successURL: NSURL = NSURL(string: "")!
    
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
        let url = request.URL
        
        if url == _successURL {
            return false
        }
        
        return true
    }
}
