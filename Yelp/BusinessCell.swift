//
//  BusinessCellTableViewCell.swift
//  A cell in the business list table
//  Yelp
//
//  Created by Minnie Lai on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            posterImageView.setImageWith(business.imageURL!)
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            distanceLabel.text = business.distance
            reviewsCount.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWith(business.ratingImageURL!)
        }
    }
    
    // layoutSubviews to let AutoLayout know that name label should be
    // wrapped at the preferredMaxLayoutWidth = width
    override func layoutSubviews() {
        super.layoutSubviews() // always call the parent function
        self.contentView.layoutIfNeeded() // needed this method so that the initial view would load correctly
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.width

    }
    
    override func awakeFromNib() {
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.width
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 3
        posterImageView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
