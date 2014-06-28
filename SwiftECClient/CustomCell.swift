//
//  CustomCell.swift
//  SwiftECClient
//
//  Created by naoto yamaguchi on 2014/06/22.
//  Copyright (c) 2014 naoto yamaguchi. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var titleLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    var itemImage: UIImageView = UIImageView()
    var starButton: UIButton = UIButton()
    var imageCache: ImageCache = ImageCache()

    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        
        // label
        self.titleLabel.frame = CGRect(x: 90, y: 10, width: 220, height: 20)
        self.titleLabel.font = UIFont.systemFontOfSize(12.0)
        self.titleLabel.lineBreakMode = .ByCharWrapping
        self.titleLabel.numberOfLines = 0
        self.contentView.addSubview(self.titleLabel)
        
        // description
        self.descriptionLabel.frame = CGRect(x: 90, y: 30, width: 220, height: 50)
        self.descriptionLabel.font = UIFont.systemFontOfSize(10)
        self.descriptionLabel.lineBreakMode = .ByCharWrapping
        self.descriptionLabel.numberOfLines = 0
        self.contentView.addSubview(self.descriptionLabel)
        
        // image
        self.itemImage.frame = CGRect(x: 10, y: 15, width: 65, height: 65)
        self.contentView.addSubview(self.itemImage)
        
        // star button
        self.starButton.frame = CGRect(x: 90, y: 85, width: 90, height: 25)
        self.starButton.setTitle("Star", forState: .Normal)
        self.starButton.backgroundColor = UIColor.grayColor()
        self.starButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.starButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        self.contentView.addSubview(self.starButton)
    }
    
    func setItemEntity(entity: NSDictionary, indexPath: NSIndexPath) {
        
        self.titleLabel.text = entity["Name"] as String
        self.descriptionLabel.text = entity["Description"] as String
        
        let q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let q_main: dispatch_queue_t = dispatch_get_main_queue()
        
        // image chache method
        if self.imageCache.dequeueImageByIndexPath(indexPath) {
            self.itemImage.image = self.imageCache.dequeueImageByIndexPath(indexPath)
        }
        else {
            
            dispatch_async(q_global, {
                
                let imagePath: String = entity.objectForKey("Image")?.objectForKey("Medium") as String
                let imageURL: NSURL = NSURL.URLWithString(imagePath)
                let imageData: NSData = NSData(contentsOfURL: imageURL)
                let image: UIImage = UIImage(data: imageData)
                
                self.imageCache.enqueueImage(image, indexPath: indexPath)
                
                dispatch_async(q_main, {
                    self.itemImage.image = image
                    self.layoutSubviews()
                })
                
            })
            
        }
        
    }
    
    class func cellHeight() -> CGFloat! {
        return 120
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
