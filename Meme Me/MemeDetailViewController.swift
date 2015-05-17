//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by David Truong on 16/05/2015.
//  Copyright (c) 2015 David Truong. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var meme: Meme!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.imageView.image = meme.memedImage
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme:")
        let deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteMeme:")
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
        fixedSpace.width = 50.0

        self.navigationItem.rightBarButtonItems = [editButton, deleteButton]

    }

    func editMeme(sender:UIButton!) {
        // Go *back* to the RootViewController
        let editorVC = self.navigationController!.viewControllers[0] as! MemeEditorViewController
        editorVC.memeRestore = meme

        self.navigationController!.popViewControllerAnimated(true)
        self.navigationController!.popToRootViewControllerAnimated(true)
    }

    func deleteMeme(sender:UIButton!) {
        // Couldn't work out how to delete a meme
        // Kept getting error: "Cannot invoke 'find' with an argument list of type '([Meme]), Meme!)
    }
}
