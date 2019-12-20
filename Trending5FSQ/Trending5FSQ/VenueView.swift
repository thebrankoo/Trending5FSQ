//
//  VenueView.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/20/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import UIKit

class VenueView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    class func instanceFromNib() -> VenueView {
        return UINib(nibName: "VenueView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VenueView
    }
}
