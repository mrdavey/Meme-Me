//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by David Truong on 15/05/2015.
//  Copyright (c) 2015 David Truong. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var allMemes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

    // Fix for buggy nav bar overlapping tableview: http://stackoverflow.com/a/28879100/4769084
    override func viewDidLayoutSubviews() {
        if let var rect = self.navigationController?.navigationBar.frame {
            var y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMemes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MemeTableViewCell
        let memeCell = self.allMemes[indexPath.row]

        // Set text and image
        cell.backgroundMeme.image = memeCell.originalImage
        cell.topText.text = memeCell.topText
        cell.bottomText.text = memeCell.bottomText
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView")! as! MemeDetailViewController

        detailVC.meme = self.allMemes[indexPath.row]

        self.navigationController!.pushViewController(detailVC, animated: true)
    }

}
