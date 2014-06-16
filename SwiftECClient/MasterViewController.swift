//
//  MasterViewController.swift
//  SwiftECClient
//
//  Created by naoto yamaguchi on 2014/06/10.
//  Copyright (c) 2014年 naoto yamaguchi. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIRequestDelegate {

    var tableView: UITableView!
    let requester: APIRequest!
    var jsonArray: NSArray = NSArray()
    let cellID: String = "cellID"
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Swift EC Client"
        self.requester = APIRequest(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requester.request()
    }
    
    override func loadView() {
        super.loadView()
        
        self.tableView = UITableView(frame: self.view.frame, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    func didRequest(data: NSData, responseHeaders: NSDictionary, error: NSError?) {
        
        if (error) {
            println("error did Request")
        }
        else {
            
            if let validArray: NSArray = Parser.jsonParser(data) {
                self.jsonArray = validArray
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
            else {
                println("error json parser")
            }
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jsonArray.count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell
        let item: NSDictionary = self.jsonArray[indexPath.row] as NSDictionary
        
        cell.lineBreakMode = .ByCharWrapping
        cell.textLabel.numberOfLines = 0
        cell.text = item["Name"] as String
        
        var q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        var q_main: dispatch_queue_t = dispatch_get_main_queue()
        
        dispatch_async(q_global, {
            
            var imagePath: String = item.objectForKey("Image")?.objectForKey("Medium") as String
            var imageURL: NSURL = NSURL.URLWithString(imagePath)
            var imageData: NSData = NSData(contentsOfURL: imageURL)
            var image: UIImage = UIImage(data: imageData)
            
            dispatch_async(q_main, {
                cell.image = image
                cell.layoutSubviews()
            })
            
        })
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
