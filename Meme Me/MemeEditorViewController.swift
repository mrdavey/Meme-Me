//
//  MemeEditorViewController.swift
//  Meme Editor
//
//  Created by David Truong on 6/05/2015.
//  Copyright (c) 2015 David Truong. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var memedImage: UIImage?
    var memeRestore: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()

        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0,
        ]

        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes

        topTextField.text = "TOP"
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = NSTextAlignment.Center
    
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Subscribe to keyboard notifications
        self.subscribeToKeyboardNotifications()

        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if imageView?.image == nil {
            self.shareButton.enabled = false
        } else {
            self.shareButton.enabled = true
        }

        if let meme = memeRestore {
            self.topTextField.text = meme.topText
            self.bottomTextField.text = meme.bottomText
            self.imageView?.image = meme.originalImage

            self.shareButton.enabled = true
            self.memeRestore = nil
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func YourMemeCollectionButton(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showSavedMemes", sender: sender)
    }

    // --------------------
    // MARK: - Meme Objects
    // --------------------

    @IBAction func shareButton(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let memeMessage = "Look at this great meme!"

        let activityVC = UIActivityViewController(activityItems: [memeMessage, memedImage!], applicationActivities: nil)

        activityVC.completionWithItemsHandler = { activity, success, items, error in
            var alert = UIAlertController(title: "Save?", message: "Would you like to save the current meme", preferredStyle: .Alert)

            alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { action in
                self.memedImage = self.generateMemedImage()
                self.save()
                self.YourMemeCollectionButton(sender)
            }))

            alert.addAction(UIAlertAction(title: "No", style: .Destructive, handler: nil))

            self.presentViewController(alert, animated: true, completion: nil)
        }

        self.presentViewController(activityVC, animated: true, completion: nil)

    }

    func save() {
        // Create the meme
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imageView!.image!, memedImage: memedImage!)

        // Add it to the Memes array on the AppDelegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        println("Saved Image!")
    }

    func generateMemedImage() -> UIImage {

        // Hide toolbar and navbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.sharedApplication().statusBarHidden = true
        self.toolBar.hidden = true
        self.bottomConstraint.constant = 10

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.sharedApplication().statusBarHidden = false
        self.bottomConstraint.constant = 44
        self.toolBar.hidden = false

        return memedImage
    }



    // --------------------
    // MARK: - TextField functions
    // --------------------

    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    // Shift the view above the keyboard height
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification) - 44 // minus toolbar height
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    // Shift the view back to normal
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification) - 44
        }
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    // --------------------
    // MARK: - ImagePicker functions
    // --------------------

    @IBAction func pickerButton(sender: UIBarButtonItem) {
        showPickerView()
    }

    func showPickerView() {
        let imagePickerControl = UIImagePickerController()
        imagePickerControl.delegate = self
        imagePickerControl.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerControl, animated: true, completion: nil)
    }

    @IBAction func cameraButton(sender: UIBarButtonItem) {
        showCameraView()
    }

    func showCameraView() {
        let imagePickerControl = UIImagePickerController()
        imagePickerControl.delegate = self
        imagePickerControl.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePickerControl, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView!.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

