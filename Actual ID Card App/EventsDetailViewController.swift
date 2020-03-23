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
    
    override func viewDidLoad() {
        detailLabel.text = event?.detail
    }
}
