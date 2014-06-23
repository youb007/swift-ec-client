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
    var imageChache: Dictionary<NSIndexPath, UIImage> = Dictionary<NSIndexPath, UIImage>()

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
        self.itemImage.frame = CGRect(x: 15, y: 10, width: 60, height: 60)
        self.contentView.addSubview(self.itemImage)
        
    }
    
    func setItemEntity(entity: NSDictionary, indexPath: NSIndexPath) {
        
        self.titleLabel.text = entity["Name"] as String
        self.descriptionLabel.text = entity["Description"] as String
        
        let q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let q_main: dispatch_queue_t = dispatch_get_main_queue()
        
        if imageChache[indexPath] {
            self.itemImage.image = self.imageChache[indexPath] as UIImage
        }
        else {
            
            dispatch_async(q_global, {
                
                let imagePath: String = entity.objectForKey("Image")?.objectForKey("Medium") as String
                let imageURL: NSURL = NSURL.URLWithString(imagePath)
                let imageData: NSData = NSData(contentsOfURL: imageURL)
                let image: UIImage = UIImage(data: imageData)
                
                self.imageChache[indexPath] = image
                
                dispatch_async(q_main, {
                    self.itemImage.image = image
                    self.layoutSubviews()
                })
                
            })
            
        }
        
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
