//
//  ViewController.swift
//  Actual ID Card App
//
//  Created by Michael Que on 10/23/19.
//  Copyright © 2019 Michael Que. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var iDImageButton: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    
    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Make ID Card imageview rounded
        self.iDImageButton.layer.cornerRadius = self.iDImageButton.frame.size.width / 15
        self.iDImageButton.clipsToBounds = true
        
        //staff directory search box effetcs
        
    getVid(videocode:"396057673")
        
        
//ID CARD PICTURE
        
        if let iDPicture = loadImageFromDiskWith(fileName: "iDPicture.jpeg") {
            iDImageButton.setBackgroundImage(iDPicture, for: .normal)
            iDImageButton.setTitle("", for: .normal)
            
        
        }
        
        
        
    }
    
    


    @IBAction func importImageButton(_ sender: Any) {
        pickerController.delegate = self
        pickerController.sourceType=UIImagePickerController.SourceType.photoLibrary
        pickerController.allowsEditing = false
        
        self.present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as?UIImage {
            
            iDImageButton.setBackgroundImage(image, for: .normal)
            iDImageButton.setTitle("", for: .normal)
            saveImage(imageName: "iDPicture.jpeg", image: image )
        } else {
            print("Failed to pick image")
        }
        self.dismiss(animated: true, completion: nil)
    }

    func saveImage(imageName: String, image: UIImage) {
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }

    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    //Potenially video functionaility
    
    func getVid(videocode:String) {
      let request = URLRequest(url: URL(string: "https://player.vimeo.com/video/\(videocode)")!)
        webView.load(request)
    }
    
}

    
    
    
    
