//
//  ViewController.swift
//  Actual ID Card App
//
//  Created by Michael Que on 10/23/19.
//  Copyright © 2019 Michael Que. All rights reserved.
//

import UIKit
import WebKit
import VimeoNetworking
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
        
  
    setUpVimeo()
    
//ID CARD PICTURE
        
        if let iDPicture = loadImageFromDiskWith(fileName: "iDPicture.jpeg") {
            iDImageButton.setBackgroundImage(iDPicture, for: .normal)
            iDImageButton.setTitle("", for: .normal)
            
        
        }
        
        
        
    }
    
    func setUpVimeo (){
        let appConfiguration = AppConfiguration(
        clientIdentifier: "fb1e62c9daa056fa8cb699d1fb39d32c4910c6fd",
        clientSecret: "qFf2tiv51aU6pPWLEaIbJdSgoVSYpfIICnwa3ZFp/a8LguiXmNhOENZlUBv7O7c16BFCmHWCL1NbHrZOuoFF1FiqROAN2EVNqp+tM/trv1T9NagM73fdtG7MI7zlw2a3",
        scopes: [.Public, .Private, .Interact], keychainService: "KeychainServiceVimeo")

        let vimeoSessionManager = VimeoSessionManager.defaultSessionManager(
                baseUrl: VimeoBaseURL,
                accessToken: "d5b26cea44e3181986d69c382cf90950",
                apiVersion: "3.4")
        let vimeoClient = VimeoClient(
                appConfiguration: appConfiguration,
                sessionManager: vimeoSessionManager)
        let videoRequest = Request<[VIMVideo]>(path: "/users/lelandchargers/videos")
        vimeoClient.request(videoRequest) {
                result in
                switch result {
                case .success(let response):
                    let videos: [VIMVideo] = response.model
                    let video = videos[0]
                    let uri = video.uri
                    let parsedVideoCode = uri?.replacingOccurrences(of: "/videos/", with: "")
                    print("\n\n retrieved videos: \(videos) \n\n")
                    print("link: \(link)")
                    self.getVid(videocode:parsedVideoCode!)
                case .failure(let error):
                    print("\n\n error retrieving videos: \(error) \n\n")
                }
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

    
    
    
    
