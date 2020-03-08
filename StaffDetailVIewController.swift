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
class StaffDetailViewController: UIViewController {
    
    var staff:Staff?
    
    @IBOutlet weak var staffName: UILabel!
    
    @IBOutlet weak var emailLabel: UIButton!
    @IBOutlet weak var websiteLabel: UIButton!
   
    
    override func viewDidLoad() {
        
        staffName.text = staff?.name
        emailLabel.setTitle(staff?.email,for: .normal)
        if staff?.website == nil {
            websiteLabel.isHidden = true
            
        }
        
       
//        websiteLabel.setTitle(staff!.website?.values, for: .normal)
       
        
       
        
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

        // read from clipboard
       func CopiedAlert (title:String, message:String)
              {
                  let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                  alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { (acting) in
                      alert.dismiss(animated: true, completion: nil)
                  }))
                  
                  self.present(alert, animated: true, completion: nil)
              }
        
        CopiedAlert(title: "Success", message: "Email Copied")
       
        
       
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
