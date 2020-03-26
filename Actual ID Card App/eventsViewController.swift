//
//  eventsViewController.swift
//  Leland HS App
//
//  Created by Michael Que on 11/20/19.
//  Copyright © 2019 Michael Que. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestore


struct MonthSection {
    var monthYear:String
    var eventArray:[Event]
    
}

class eventsViewController: UIViewController {
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var dateButton: UIButton!
    var toolBar = UIToolbar()
    let db = Firestore.firestore()
    var eventArray:[Event] = []
    var monthSections = [MonthSection]()

    
    override func viewDidLoad() {
        loadEventData()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
        eventsTableView.dataSource = self
        eventsTableView.delegate = self

        
    }
    
    @IBAction func DateButton(_ sender: Any) {
        pickerView.isHidden = false
        
        
        
        
        
    }
    
    
    
    
    func loadEventData(){
        self.db.collection("events").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for EventDocument in querySnapshot!.documents {
                    // 1. documentdata() is a dictionary for a staff, convert this into Staff object
                    let EventDictionary = EventDocument.data()
                    let FireBaseDate = EventDictionary["date"] as! Timestamp
                    let date = FireBaseDate.dateValue()
                    let event:Event = Event.init(name: EventDictionary["name"] as! String, date: date, detail: EventDictionary["detail"] as! String)
                    let month = event.getMonthYear()
                    print(month)
                    // 2. Add staff object into staffArray
                    self.eventArray.append(event)
                }

                //Groups eventArray by Month
                let groups = Dictionary(grouping: self.eventArray, by: {event in event.getMonthYear() })
                
                self.monthSections = groups.map { (key,values) in
                    return MonthSection(monthYear: key, eventArray: values)
                }
                self.monthSections.sort { (lhs: MonthSection, rhs: MonthSection) -> Bool in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM, yyyy"
                    return dateFormatter.date(from: lhs.monthYear)! < dateFormatter.date(from: rhs.monthYear)!
                }
                self.eventsTableView.reloadData()
                self.pickerView.reloadAllComponents()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM, yyyy"
                let currentMonthYear = dateFormatter.string(from: NSDate() as Date)
                
                var sectionIndex = 0
                
                //Gets sectionIndex of current month to scroll and display current month in pickerView
                for i in self.monthSections.indices {
                    let monthSection = self.monthSections[i]
                    if (monthSection.monthYear == currentMonthYear) {
                            sectionIndex = i
                    }
                    //TODO: MAKE CODE FOR IF NO EVENT EXISTS IN MONTH
                }
                self.dateButton.setTitle(currentMonthYear, for: .normal)
                let indexPath = NSIndexPath(item: 0, section: sectionIndex)
                self.eventsTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
                self.pickerView.selectRow(sectionIndex, inComponent:0, animated:true)
            }
            
        }
        
    }
}
extension eventsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monthSections.count
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Change events
        pickerView.isHidden = true
        let indexPath = NSIndexPath(item: 0, section: row)
        self.eventsTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
        let monthSection = monthSections[row]
               
        dateButton.setTitle(monthSection.monthYear, for: .normal)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let monthSection = monthSections[row]
        return monthSection.monthYear
        
    }
    
    
}

extension eventsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let monthSection: MonthSection = self.monthSections[section]
        return monthSection.monthYear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.monthSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let monthSection : MonthSection = self.monthSections[section]
        return monthSection.eventArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell")!
        
        
        let monthSection : MonthSection = self.monthSections[indexPath.section]
        let event:Event = monthSection.eventArray[indexPath.row]
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let dateString = formatter.string(from: event.date)
        
        
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = dateString
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                let vc = storyboard?.instantiateViewController(identifier: "eventsDetailViewController") as? EventsDetailViewController
                let monthSection : MonthSection = self.monthSections[indexPath.section]
                let event:Event = monthSection.eventArray[indexPath.row]
                vc?.event = event
                self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

