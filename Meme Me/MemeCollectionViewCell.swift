//
//  MemeCollectionViewCell.swift
//  Meme Me
//
//  Created by David Truong on 11/05/2015.
//  Copyright (c) 2015 David Truong. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    func setText (topText: String, bottomText: String) {
        self.topLabel.text = topText
        self.bottomLabel.text = bottomText
    }
}
