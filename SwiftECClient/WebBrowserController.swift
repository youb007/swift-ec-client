//
//  WebBrowserController.swift
//  SwiftECClient
//
//  Created by naoto yamaguchi on 2014/06/28.
//  Copyright (c) 2014 naoto yamaguchi. All rights reserved.
//

import UIKit

class WebBrowserController: UIViewController, UIWebViewDelegate, UIActionSheetDelegate {
    
    var webView: UIWebView = UIWebView()
    var toolBar: UIToolbar = UIToolbar()
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    var refreshButton: UIBarButtonItem!
    var safariButton: UIBarButtonItem!
    var urlString: String = String()
    
    let toolBarHeight: CGFloat = 50.0
    
    init(urlString: String) {
        super.init(nibName: nil, bundle: nil)
        
        let selfFrame: CGRect = self.view.frame
        
        self.webView.frame = CGRect(x: 0, y: 0, width: selfFrame.size.width, height: selfFrame.size.height-toolBarHeight)
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        
        self.toolBar.frame = CGRect(x: 0, y: selfFrame.size.height - toolBarHeight, width: selfFrame.size.width, height: toolBarHeight)
        self.view.addSubview(self.toolBar)
        
        self.urlString = urlString
    }
    
    override func loadView() {
        super.loadView()
        
        let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.backButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: Selector("back"))
        self.forwardButton = UIBarButtonItem(title: "Forward", style: .Plain, target: self, action: Selector("forward"))
        self.refreshButton = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: Selector("reflesh"))
        self.safariButton = UIBarButtonItem(title: "Safari", style: .Plain, target: self, action: Selector("safari"))
        let items: NSArray = [spacer, self.backButton, spacer, self.forwardButton, spacer, self.refreshButton, spacer, self.safariButton, spacer]
        self.toolBar.items = items
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
        self.refreshButton.enabled = false
        self.safariButton.enabled = false
    }
    
    func requestURLFromString(HTMLString: String) -> NSURLRequest {
        let url: NSURL = NSURL.URLWithString(HTMLString)
        let urlRequest: NSURLRequest = NSURLRequest(URL: url)
        return urlRequest
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Util.showNetworkIndicatorVisible()
        let requestURL: NSURLRequest = self.requestURLFromString(self.urlString)
        self.webView.loadRequest(requestURL)
    }
    
    func back() {
        self.webView.goBack()
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
    }
    
    func forward() {
        self.webView.goForward()
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
    }
    
    func reflesh() {
        self.webView.reload()
    }
    
    func safari() {
        // TODO: judge OS
        if Util.osVersion() == "8.0" {
            self.alertController()
        }
        else {
            self.actionSheet()
        }
        
    }
    
    func alertController() {
        let actionSheet: UIAlertController = UIAlertController(title: "ios8 action sheet", message: "message", preferredStyle: .ActionSheet)
        
        let otherAction1: UIAlertAction = UIAlertAction(title: "Open in Safari", style: UIAlertActionStyle.Default, handler: { action1 in
            
            let url: NSURL = self.webView.request.URL
            UIApplication.sharedApplication().openURL(url)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { cancel in })
        
        actionSheet.addAction(otherAction1)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func actionSheet() {
        let actionSheet: UIActionSheet = UIActionSheet()
        actionSheet.title = "ios7 action sheet"
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("Open in Safari")
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.cancelButtonIndex = 1
        actionSheet.showFromToolbar(self.toolBar)
    }
    
    func actionSheet(myActionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        switch (buttonIndex) {
            case 0:
                let url: NSURL = self.webView.request.URL
                UIApplication.sharedApplication().openURL(url)
                break
            default:
                break
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        Util.showNetworkIndicatorVisible()
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
        self.refreshButton.enabled = true
        self.safariButton.enabled = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        Util.hideNetworkIndicatorVisible()
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
