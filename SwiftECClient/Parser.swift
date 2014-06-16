//
//  Parser.swift
//  SwiftECClient
//
//  Created by naoto yamaguchi on 2014/06/10.
//  Copyright (c) 2014年 naoto yamaguchi. All rights reserved.
//

import UIKit

class Parser: NSObject {
    
    class func jsonParser(responseData: NSData!) -> NSArray? {
        
        var itemsArray: NSMutableArray = NSMutableArray()
        var jsonError: NSError?
        var json: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments, error: &jsonError) as NSDictionary
        
        if jsonError {
            return nil;
        }
        
        // keyにアクセスする時はoptional bindingがいいかも
        let resultJson: NSDictionary = json.objectForKey("ResultSet")?.objectForKey("0")?.objectForKey("Result") as NSDictionary
        let count: Int = resultJson.count - 3
        
        // mapで書ける?
        for i: Int in 0..count {
            let num: String = "\(i)"
            itemsArray.addObject(resultJson[num])
        }
        
        return itemsArray
    }
}
