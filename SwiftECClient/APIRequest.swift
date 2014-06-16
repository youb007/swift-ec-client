//
//  APIRequest.swift
//  SwiftECClient
//
//  Created by naoto yamaguchi on 2014/06/10.
//  Copyright (c) 2014年 naoto yamaguchi. All rights reserved.
//

import UIKit

protocol APIRequestDelegate: NSObjectProtocol {
    func didRequest(data: NSData, responseHeaders: NSDictionary, error: NSError?)
}

class APIRequest: NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate {
    
    var delegate: APIRequestDelegate?
    var responseData: NSMutableData = NSMutableData()
    var responseHeaders: NSDictionary = NSDictionary()
    
    init(delegate: APIRequestDelegate) {
        super.init()
        self.delegate = delegate
        self.responseData = NSMutableData()
    }
    
    // APPID class is .gitignore
    func request() {
        var appID:String = APPID.appID()
        var urlString:String = "http://shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch?appid=\(appID)&category_id=1034&hits=20"
        var url: NSURL = NSURL.URLWithString(urlString)
        var session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                                      delegate: self,
                                                 delegateQueue: NSOperationQueue())
        var dataTask: NSURLSessionDataTask = session.dataTaskWithURL(url)
        dataTask.resume()
    }
    
    func URLSession(session: NSURLSession!, dataTask: NSURLSessionDataTask!, didReceiveResponse response: NSURLResponse!, completionHandler: ((NSURLSessionResponseDisposition) -> Void)!) {
        
        let statusCode:Int = (response as NSHTTPURLResponse).statusCode
        
        if (statusCode >= 400) {
            let dict: Dictionary = [NSLocalizedDescriptionKey: "statusCode error"]
            let error: NSError = NSError.errorWithDomain("swift.sample.app", code: statusCode, userInfo: dict)
            URLSession(session, task: dataTask, didCompleteWithError: error)
            return
        }
        
        self.responseHeaders = (response as NSHTTPURLResponse).allHeaderFields
        
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession!, dataTask: NSURLSessionDataTask!, didReceiveData data: NSData!) {
        self.responseData.appendData(data)
    }
    
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didCompleteWithError error: NSError!) {
        self.delegate?.didRequest(self.responseData, responseHeaders: self.responseHeaders, error: error)
    }
}
