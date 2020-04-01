//
//  EventsDetailViewController.swift
//  Leland HS App
//
//  Created by Michael Que on 3/23/20.
//  Copyright © 2020 Michael Que. All rights reserved.
//

import Foundation
import UIKit
class EventsDetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailLabel: UILabel!
    var event:Event?
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        detailLabel.text = event?.detail
        eventLabel.text = event?.name
        
        let formatter = DateFormatter()
              formatter.dateFormat = "dd-MMM-yyyy"
              // again convert your date to string
        let dateString = formatter.string(from: event!.date)
        dateLabel.text = dateString
        
        
    }
    
    
}
