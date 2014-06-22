//
//  Util.swift
//  SwiftECClient
//
//  Created by naoto yamaguchi on 2014/06/18.
//  Copyright (c) 2014 naoto yamaguchi. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    class func showNetworkIndicatorVisible() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    class func hideNetworkIndicatorVisible() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    class func osVersion() -> String {
        return UIDevice.currentDevice().systemVersion
    }
}
