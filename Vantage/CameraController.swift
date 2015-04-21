//
//  SecondViewController.swift
//  Vantage
//
//  Created by Apprentice on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import Parse

class CameraController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var collectionTransfer: NSObject = "";
    var holder: NSObject = "";

        
    @IBAction func showMeTheCamera(sender: AnyObject) {
        showCamera()
    }
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            println("captureVideoPressed and camera available.")
            
            var imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = false
            imagePicker.showsCameraControls = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            navigationController?.popToRootViewControllerAnimated(true)
            
        }
            
        else {
            println("Camera not available.")
        }
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
                redirectPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        showCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
 
        let pathString = tempImage.relativePath
        self.dismissViewControllerAnimated(true, completion: {})
        
        let videoData = NSData(contentsOfURL: tempImage)
        let videoFile = PFFile(name:"move.mov", data:videoData!)
        println(videoFile)
        
        let userVideo = PFObject(className: "Videos")
        userVideo["video"] = videoFile
        
        let userCollection = PFObject(className: "Collection")
        println(userCollection)
        

        userCollection.addObject(userVideo, forKey: "videos")
        println(userCollection)
        
        let currentUser = PFUser.currentUser()
        userVideo["creator"] = currentUser
        println(currentUser)
        
        userCollection.addObject(currentUser!, forKey: "collaborators")
        println(userCollection)
        
        userCollection.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if success {
                NSLog("Object create with id: (userCollection.objectId")
            } else {
                NSLog("We have an error")
            }
        }
        
        userVideo.saveInBackground()

        self.collectionTransfer = userCollection as NSObject
        
        self.holder = self.collectionTransfer

//        redirectFriends()
        
        self.performSegueWithIdentifier("transfer", sender: self)
    
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("GOT TO OVERRIDE FUNCTION")
        var DestViewController : FriendsListController = segue.destinationViewController as! FriendsListController
        
        DestViewController.collectionObject = self.holder
        
    }
    
   
    
//    func redirectFriends(){
//        println("*************THIS IS THE SELF.COLLECTIONTRANSFER:************")
//        println(self.collectionTransfer)
//        
//        self.performSegueWithIdentifier("transfer", sender: self)
////
////        
////        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("friendsList")as! FriendsListController
////        self.presentViewController(vc, animated: true, completion: nil)
//    }
    
    
    
    func redirectPage(){
        tabBarController!.selectedViewController = tabBarController?.viewControllers!.first as? UIViewController
        navigationController?.popToRootViewControllerAnimated(true)
    }

}


