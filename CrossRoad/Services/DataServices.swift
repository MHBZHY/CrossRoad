//
//  DataServices.swift
//  eMall-quick
//
//  Created by zhy on 15/7/7.
//  Copyright (c) 2015年 zhy. All rights reserved.
//

import Foundation
import CoreLocation

struct shopData {
    var shopNameLabel: String
    var shopIntroductionTextView: String
    var webview: NSURL
}

extension String {
	func sha1() -> String {
		let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
		var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
		CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
		let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
		for byte in digest {
			output.appendFormat("%02x", byte)
		}
		return output as String
	}
}

public class Message {
    private var titleLabel: String
    private var detailLabel: String
    private var imageName: String
    
    init(titleLabel: String, detailLabel: String,  imageName: String) {
        self.titleLabel = titleLabel
        self.detailLabel = detailLabel
        self.imageName = imageName
    }
    
    func getTitleLabel() -> String {
        return titleLabel
    }
    
    func getDetailLabel() -> String {
        return detailLabel
    }
    
    func getImageName() -> String {
        return imageName
    }
}

public class Mall {
    
    private var location: CLLocation
    private var name: String!
    
    init(name: String, location: CLLocation) {
        self.location = location
        self.name = name
    }
    
    func getMallName() -> String {
        return name
    }
    
    func getMallLocation() -> CLLocation {
        return location
    }
    
    func setMallName(name: String) {
        self.name = name
    }
    
    func setMallLocation(location: CLLocation) {
        self.location = location
    }
}

enum District: Int {
	case HaiDian = 0
	case DongCheng
	case Xicheng
	case ChaoYang
	case ShiJingShan
	case FengTai
	case ShunYi
	case HuaiRou
	case MiYun
	case YanQing
	case ChangPing
	case PingGu
	case MenTouGou
	case FangShan
	case TongZhou
}

/*public class globalVariable {
    
    class func getSiteURL() -> String {
        return "http://zhy-rmbp.local:8081/"
    }
    
    class func getCarouselImagePath() -> String {
        return "homepage_img/CarouselImage/"
    }
    
    class func getActionPHPPath() -> String {
        return "test.php?action="
    }
    
    class func getPostPHPPath() -> String {
        return "hehe.php"
    }
}*/