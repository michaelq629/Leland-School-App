//
//  dates.swift
//  Leland HS App
//
//  Created by Michael Que on 12/20/19.
//  Copyright © 2019 Michael Que. All rights reserved.
//

import Foundation

struct Event {
    var name: String
    var date:Date
    var detail:String
    
    func getMonthYear () -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        let monthYear = dateFormatter.string(from: self.date)
        return monthYear
        
    }
    
}
