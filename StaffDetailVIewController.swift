//
//  StaffDetailVC.swift
//  Leland HS App
//
//  Created by Michael Que on 11/19/19.
//  Copyright © 2019 Michael Que. All rights reserved.
//
import MessageUI
import Foundation
import UIKit
import LetterAvatarKit
import SVProgressHUD
class StaffDetailViewController: UIViewController {
    
    var staff:Staff?
    
    @IBOutlet weak var staffName: UILabel!
    @IBOutlet weak var emailLabel: UIButton!
    @IBOutlet weak var websiteLabel: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        
        staffName.text = staff?.name
        emailLabel.setTitle(staff?.email,for: .normal)
        if staff?.website == nil {
            websiteLabel.setTitleColor(.black, for: .normal)
            websiteLabel.setTitle("No Website Available", for: .normal)
            
        }
        if let website = staff?.website{
               if website.count == 1{
               let websiteURL = Array(website.values)[0]
                   websiteLabel.setTitle(websiteURL, for: .normal)
            }
               else {
                websiteLabel.setTitle("Websites", for: .normal)
            }
            
        }
        
       let configuration = LetterAvatarBuilderConfiguration()
        configuration.username = staff?.name
        configuration.circle = true
        configuration.lettersFont = UIFont.systemFont(ofSize: 25, weight: .bold)
        configuration.lettersColor = .white
        configuration.backgroundColors = [UIColor.init(red:211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)]
        profilePic.image = UIImage.makeLetterAvatar(withConfiguration: configuration)
    }
    
    @IBAction func websiteAction(_ sender: Any) {
        //use action sheet
       
        
        // If mutiple values
        if let website = staff?.website {
            if  website.count > 1 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheet.addAction(cancel)
                //For loop
                for (subject, url) in website {
                    
                    let action = UIAlertAction(title: subject, style: .default) { (action) in
                        let websiteURL = website[action.title!]
                        if let url = URL(string: websiteURL!) {
                            UIApplication.shared.open(url)
                        }
//
                    }
                    actionSheet.addAction(action)

                }
    
                present(actionSheet,animated: true, completion: nil)
    
                
            } else {
                let websiteURL = Array(website.values)[0]
                if let url = URL(string: websiteURL) {
                    UIApplication.shared.open(url)
                }
        }
        
        
        
                
    }
        
    }
    
    @IBAction func emailAction(_ sender: Any) {
        
        UIPasteboard.general.string = staff?.email
        SVProgressHUD.showInfo(withStatus: "Copy Sucessful")
       
        
       
//            if MFMailComposeViewController.canSendMail() {
//                 let mailComposeViewController = MFMailComposeViewController()
//                mailComposeViewController.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
//                mailComposeViewController.setToRecipients([staff!.email])
//                 mailComposeViewController.setSubject("Subject")
//                 mailComposeViewController.setMessageBody("Hello!!!", isHTML: false)
//                 present(mailComposeViewController, animated: true, completion: nil)
//
//            }
    
    
}
}
