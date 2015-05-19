//
//  MemeCollectionViewController.swift
//  Meme Me
//
//  Created by David Truong on 11/05/2015.
//  Copyright (c) 2015 David Truong. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

        // Reload data when meme is deleted
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MemeCollectionViewCell

        let meme = memes[indexPath.item]
        cell.setText(meme.topText, bottomText: meme.bottomText)
        let imageView = UIImageView(image: meme.originalImage)
        cell.backgroundView = imageView

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorView")! as! MemeEditorViewController

        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView")! as! MemeDetailViewController

        detailVC.meme = self.memes[indexPath.row]
        detailVC.index = indexPath.row

        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
