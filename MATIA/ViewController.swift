//
//  ViewController.swift
//  MATIA
//
//  Created by Tran Van Hien on 2018/01/08.
//  Copyright © 2018 Tran Van Hien. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePicked: UIImageView!
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Infinitely run the main loop to wait for our request.
    // Only necessary if you are testing in the command line.
    //RunLoop.main.run()

    @IBAction func openPhotoLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image               // setting the screen
        picker.dismiss(animated:true, completion: nil)
        
        //hoang Get URL
        /*let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName         = imageUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.appendingPathComponent(imageName!)
        print("localPath = ",localPath!)*/
        
        let imageData = UIImageJPEGRepresentation(image,0.5)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName: "file",fileName: "unicorn.jpg", mimeType: "image/jpg")
                //multipartFormData.append(fileContent.data(using: String.Encoding.utf8)!, withName: "rainbow.txt", fileName: "rainbow.jpg",mimeType: "image/jpg")
        },
            //to: "http://192.168.137.1:8000", // this is example of actual server address
            //to: "http://localhost:8000",
            to: "http://10.42.0.1:8000",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    //hoang
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    /*
    @IBAction func saveButt(_ sender: Any) {
        let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Wow",
                                      message: "Your image has been saved to Photo Library!",
                                      preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Default", style: .default) { (action:UIAlertAction) in
            print("You've pressed SAVE button");
        }
        alert.addAction(action1)
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myUtterance = AVSpeechUtterance(string: "Welcome to MATIA. I am an second eyes for you!")
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
        //let params = ["id": 1]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

