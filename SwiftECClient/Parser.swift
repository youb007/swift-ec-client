//
//  Parser.swift
//  SwiftECClient
//
//  Created by naoto yamaguchi on 2014/06/10.
//  Copyright (c) 2014 naoto yamaguchi. All rights reserved.
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
        
        if let result = self.getResultJSON(json) as? NSDictionary {
            
            let count: Int = result.count - 3
            for i: Int in 0..count {
                let num: String = "\(i)"
                itemsArray.addObject(result[num])
            }
            
            return itemsArray
        }
        
        return nil
    }
    
    class func getResultJSON(json: NSDictionary!) -> NSDictionary? {
        
        if let validResultSetJson = json["ResultSet"]?["0"] as? NSDictionary {
            if let validResultJson = validResultSetJson["Result"] as? NSDictionary {
                return validResultJson as NSDictionary
            }
        }
        
        return nil
    }
    
}
