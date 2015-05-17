//
//  Meme.swift
//  Meme Me
//
//  Created by David Truong on 9/05/2015.
//  Copyright (c) 2015 David Truong. All rights reserved.
//
import UIKit
import Foundation

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage:UIImage
    var memedImage:UIImage
}

// Testing equitible func to be able to delete meme.. didn't fix error
func == (lhs: Meme, rhs: Meme) -> Bool {
    return lhs.topText == rhs.topText
    //&& lhs.bottomText == rhs.bottomText && lhs.originalImage == rhs.originalImage
}
