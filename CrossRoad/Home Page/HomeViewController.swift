//
//  HomeViewController.swift
//  eMall
//
//  Created by 张海阳 on 15/6/1.
//  Copyright (c) 2015年 张海阳. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var mainTableView: UITableView!
	
    var pageCtrl: UIPageControl!
    var CarouselScrollView: UIScrollView!
    var buttonsView: UIView!
    var webview: UIWebView!
    //var _isLink = false
	var _jsonData: JSON = JSON("")
	var xibFile: [AnyObject]!
	
    override func viewDidLoad() {
		super.viewDidLoad()
		
		let carouselScrollViewHeight: CGFloat = self.view.frame.width * 0.5
		let buttonsHeight: CGFloat = carouselScrollViewHeight * 0.3
		
        //backbarbutton text
        let backButton: UIBarButtonItem = UIBarButtonItem()
        backButton.title = "返回"
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()       //white back button
        
		//carousel scrollview settings
        CarouselScrollView = UIScrollView(frame: CGRectMake(0, -(carouselScrollViewHeight + buttonsHeight), self.view.frame.width, carouselScrollViewHeight))
        CarouselScrollView.showsHorizontalScrollIndicator = false
        CarouselScrollView.pagingEnabled = true
        CarouselScrollView.delegate = self
		
        print(self.view.frame.width)
        
		//carousel subviews collection
		let count = 4		//carousel quantity
		
		for i in 0...(count - 1) {
			self.CarouselScrollView.contentSize = CGSizeMake(self.CarouselScrollView.frame.width * CGFloat(count), self.CarouselScrollView.frame.height)
			
			//initialize imageViews
			let imgView: UIImageView = UIImageView(frame: CGRectMake(CGFloat(i) * self.CarouselScrollView.frame.width, 0, self.CarouselScrollView.frame.width, self.CarouselScrollView.frame.height))
			
            //imageViews settings
			imgView.sd_setImageWithURL(NSURL(string: imgPath + "image" + (i + 1).description + ".png"), placeholderImage: UIImage(named: "placeholder.png"))
			imgView.userInteractionEnabled = true
			
			//views.append(imgView)		//add in collection
			
			//add tap event
			let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showSpecificInfoView:")
			imgView.addGestureRecognizer(tap)
			
			//add to superview
			self.CarouselScrollView.addSubview(imgView)
			self.mainTableView.addSubview(self.CarouselScrollView)
		}
        
        //create an UIView to content buttons
		buttonsView = UIView(frame: CGRectMake(0, -buttonsHeight + 10, self.view.frame.width, buttonsHeight + 15))
        buttonsView.backgroundColor = UIColor.whiteColor()
        
		//add buttons
		let buttonImageName: [String] = [
			"shirt.png", "hat.png", "pants.png", "shoes.png"
		]
		
		//add labels
		let labelName: [String] = [
			"上装", "帽饰", "下装", "鞋袜"
		]
		
		for i in 0...(buttonImageName.count - 1) {
			let labelWidth: CGFloat = 24
			let labelHeight: CGFloat = 12
			
			let x = CGFloat(i) * buttonsHeight + CGFloat(i + 1) * (self.view.frame.width - buttonsHeight * 4) / 5
			let button: UIButton = LogicServices.createHomeButton(CGRectMake(x, 0, buttonsHeight, buttonsHeight), title: nil, imageName: buttonImageName[i], radius: true)
			
			let label: UILabel = UILabel(frame: CGRectMake(button.frame.origin.x + (button.frame.width - labelWidth) / 2, buttonsHeight + (buttonsView.frame.height - buttonsHeight - labelHeight) / 2, labelWidth, labelHeight))
			label.text = labelName[i]
			label.font = label.font.fontWithSize(12)
            
            
            
			//button.restorationIdentifier = _jsonData[i * 4 + j]["url"].stringValue as String
			button.tag = i
			button.addTarget(self, action: "showSpecificInfoView:", forControlEvents: UIControlEvents.TouchUpInside)
			
			self.buttonsView.addSubview(button)
			self.buttonsView.addSubview(label)
		}
		
        //add buttonsview to mainTableView
        self.mainTableView.addSubview(buttonsView)
		
		self.mainTableView.contentInset = UIEdgeInsets(top: carouselScrollViewHeight + buttonsHeight, left: 0, bottom: 0, right: 0)
        //self.view.backgroundColor = UIColor ( red: 0.9373, green: 0.938, blue: 0.9563, alpha: 1.0 )
        
        //load data for recommand part in mainTableView
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
		
		//mainTableview cell select xib
		switch self.view.frame.width {
		case 320:
			xibFile = NSBundle.mainBundle().loadNibNamed("iPhone", owner: nil, options: nil)
		case 375:
			xibFile = NSBundle.mainBundle().loadNibNamed("iPhone6", owner: nil, options: nil)
		case 414:
			xibFile = NSBundle.mainBundle().loadNibNamed("iPhone6Plus", owner: nil, options: nil)
		default:
			break
		}
        
        //add tapRecognizer
        for i in 0...3 {
            let tap1 = UITapGestureRecognizer(target: self, action: "tapImage:")
            let tap2 = UITapGestureRecognizer(target: self, action: "tapImage:")
            let tap3 = UITapGestureRecognizer(target: self, action: "tapImage:")
            
            (self.xibFile.first as! UITableViewCell).contentView.viewWithTag(103 + i)!.addGestureRecognizer(tap1)
            (self.xibFile.first as! UITableViewCell).contentView.viewWithTag(103 + i)!.userInteractionEnabled = true
            (self.xibFile[1] as! UITableViewCell).contentView.viewWithTag(103 + i)!.addGestureRecognizer(tap2)
            (self.xibFile[1] as! UITableViewCell).contentView.viewWithTag(103 + i)!.userInteractionEnabled = true
            (self.xibFile[2] as! UITableViewCell).contentView.viewWithTag(103 + i)!.addGestureRecognizer(tap3)
            (self.xibFile[2] as! UITableViewCell).contentView.viewWithTag(103 + i)!.userInteractionEnabled = true
        }
		
		//get initialize data
        self.refresh(0)
	}
	
    override func viewDidLayoutSubviews() {
        //initialize pageControl
        self.pageCtrl = UIPageControl(frame: CGRectMake(0, self.CarouselScrollView.frame.origin.y + self.CarouselScrollView.frame.height * 0.8, self.CarouselScrollView.frame.width, 40))
        
        //pageCtrl settings
        self.pageCtrl.numberOfPages = 4
        self.pageCtrl.currentPageIndicatorTintColor = UIColor ( red: 0.9961, green: 0.7922, blue: 0.0824, alpha: 1.0 )
        self.pageCtrl.currentPage = 0
        self.pageCtrl.userInteractionEnabled = false
        self.mainTableView.addSubview(self.pageCtrl)			//add subview
    }
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    //segue passValue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "homeToSearch&Classify" {
            let dest = segue.destinationViewController as! SearchViewController
			if sender is Int {
				dest._segmentIndex = sender as! Int
			}
        }
		else if segue.identifier == "homeToGoods" {
			let dest = segue.destinationViewController as! GoodsViewController
			dest._commodity_id = sender as! Int
		}
        
        //hidesBottomBarWhenPushed
        (segue.destinationViewController ).hidesBottomBarWhenPushed = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print(_jsonData.count)
        return _jsonData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        if indexPath.section % 3 == 1 {
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("home1")
            
            if cell == nil {
                cell = self.xibFile.first as! UITableViewCell
            }
            
            (cell!.contentView.viewWithTag(101) as! UILabel).text = "上装"
            
			LogicServices.setImageView(cell!.contentView.viewWithTag(103) as! UIImageView, imageURLStr: _jsonData[indexPath.section][0]["imgpath"].stringValue)
			LogicServices.setImageView(cell!.contentView.viewWithTag(104) as! UIImageView, imageURLStr: _jsonData[indexPath.section][1]["imgpath"].stringValue)
			LogicServices.setImageView(cell!.contentView.viewWithTag(105) as! UIImageView, imageURLStr: _jsonData[indexPath.section][2]["imgpath"].stringValue)
			LogicServices.setImageView(cell!.contentView.viewWithTag(106) as! UIImageView, imageURLStr: _jsonData[indexPath.section][3]["imgpath"].stringValue)
			
            return cell!
        }
        else if indexPath.section % 3 == 2 {
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("home2")
			
            if cell == nil {
                cell = self.xibFile[1] as! UITableViewCell
            }
            
            (cell!.contentView.viewWithTag(101) as! UILabel).text = "下装"
			
            LogicServices.setImageView(cell!.contentView.viewWithTag(103) as! UIImageView, imageURLStr: _jsonData[indexPath.section][0]["imgpath"].stringValue)
            LogicServices.setImageView(cell!.contentView.viewWithTag(104) as! UIImageView, imageURLStr: _jsonData[indexPath.section][1]["imgpath"].stringValue)
            LogicServices.setImageView(cell!.contentView.viewWithTag(105) as! UIImageView, imageURLStr: _jsonData[indexPath.section][2]["imgpath"].stringValue)
            LogicServices.setImageView(cell!.contentView.viewWithTag(106) as! UIImageView, imageURLStr: _jsonData[indexPath.section][3]["imgpath"].stringValue)
			
            return cell!
        }
        else {		//if indexPath.section % 3 == 0
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("home3")
            
            if cell == nil {
                cell = self.xibFile[2] as! UITableViewCell
            }
			
            (cell!.contentView.viewWithTag(101) as! UILabel).text = "帽饰"
            
			LogicServices.setImageView(cell!.contentView.viewWithTag(103) as! UIImageView, imageURLStr: _jsonData[indexPath.section][0]["imgpath"].stringValue)
			LogicServices.setImageView(cell!.contentView.viewWithTag(104) as! UIImageView, imageURLStr: _jsonData[indexPath.section][1]["imgpath"].stringValue)
			LogicServices.setImageView(cell!.contentView.viewWithTag(105) as! UIImageView, imageURLStr: _jsonData[indexPath.section][2]["imgpath"].stringValue)
			LogicServices.setImageView(cell!.contentView.viewWithTag(106) as! UIImageView, imageURLStr: _jsonData[indexPath.section][3]["imgpath"].stringValue)
			
            return cell!
        }
    }
	
	func tapImage(tap: UITapGestureRecognizer) {
        let cell = tap.view!.superview!.superview as! UITableViewCell
        let id: Int = _jsonData[self.mainTableView.indexPathForCell(cell)!.section][tap.view!.tag - 103]["id"].intValue
        print(id)
		self.performSegueWithIdentifier("homeToGoods", sender: id)
	}
	
    func showSpecificInfoView(sender: UIButton) {
        self.performSegueWithIdentifier("homeToSearch&Classify", sender: sender.tag)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //获取scrollView视图滚动的x坐标
        let offX:CGFloat = scrollView.contentOffset.x
        
        //计算当前是第几屏
        let index:Int = (Int)(offX / scrollView.frame.width)
        
        //设置分页指示器currentPage值
        pageCtrl.currentPage = index;
    }
	
	@IBAction func refresh(sender: AnyObject) {
		request(.GET, siteURL + "recommend.php")
			.responseJSON { response in
				print(response.result.value!)
				if response.result.value != nil {
					self._jsonData = JSON(response.result.value!)
					self.mainTableView.reloadData()
				}
				else {
					NetworkServices.noInternetConnection(self)
				}
		}
	}
}

