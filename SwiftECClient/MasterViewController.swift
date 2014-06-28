//
//  MasterViewController.swift
//  SwiftECClient
//
//  Created by naoto yamaguchi on 2014/06/10.
//  Copyright (c) 2014 naoto yamaguchi. All rights reserved.
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
        
        self.itemRequest()
    }
    
    func itemRequest() {
        self.requester.request()
    }
    
    override func loadView() {
        super.loadView()
        
        self.tableView = UITableView(frame: self.view.frame, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.registerClass(CustomCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    func didRequest(data: NSData, responseHeaders: NSDictionary, error: NSError?) {
        
        if (error) {
            println("error request")
        }
        else {
            if let validArray: NSArray = Parser.jsonParser(data) as? NSArray {
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
        return CustomCell.cellHeight()
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell: CustomCell = self.tableView.dequeueReusableCellWithIdentifier(cellID) as CustomCell
        let item: NSDictionary = self.jsonArray[indexPath.row] as NSDictionary
        cell.setItemEntity(item, indexPath: indexPath)
        cell.starButton.addTarget(self, action: Selector("pressStarButton:event:"), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func pressStarButton(sender: UIButton, event: UIEvent) {
        let indexPath: NSIndexPath = self.indexPathForControlEvent(event)
        // core data insert ["Code"]
        //
        //
    }
    
    func indexPathForControlEvent(event: UIEvent) -> NSIndexPath {
        let touch: UITouch = event.allTouches().anyObject() as UITouch
        let point: CGPoint = touch.locationInView(self.tableView)
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(point)
        return indexPath
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
