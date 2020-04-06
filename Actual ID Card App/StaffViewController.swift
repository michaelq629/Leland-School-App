//
//  contactsviewconroller.swift
//  School App
//
//  Created by Michael Que on 11/13/19.
//  Copyright © 2019 Michael Que. All rights reserved.

import UIKit
import Firebase
import FirebaseFirestore

struct StaffSection {
    var subject: String
    var staffArray: [Staff]
}

class StaffViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var staffArray = [Staff]()
    var sections = [StaffSection]()
    // keytype:valuetype
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
//        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
//        searchBar.delegate = self
        loadData()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artists"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
        
        //        uploadToFirebase()
    }
    
    func loadData(){
        self.db.collection("staff").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for staffDocument in querySnapshot!.documents {
                    // 1. documentdata() is a dictionary for a staff, convert this into Staff object
                    let staffDictionary = staffDocument.data()
                    
                    let staff = Staff.init(name: staffDictionary["name"] as! String, website: staffDictionary["website"] as? Dictionary<String, String>, email: staffDictionary["email"] as! String, subject: staffDictionary["subject"] as! String )
                    // 2. Add staff object into staffArray
                    self.staffArray.append(staff)
                    
                }
                //Groups by subject
                let groups = Dictionary(grouping: self.staffArray, by: {staff in staff.subject })
                
                self.sections = groups.map { (key, staffArray) in
                    return StaffSection(subject: key, staffArray: staffArray.sorted { $0.name < $1.name })
                }
                self.sections = self.sections.sorted { $0.subject < $1.subject }
                
                   
                
               
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let staffSection: StaffSection = self.sections[section]
        return staffSection.subject
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let staffSection : StaffSection = self.sections[section]
        
      
            return staffSection.staffArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffCell")!
        
        
        let staffSection : StaffSection = self.sections[indexPath.section]
        let staff : Staff = staffSection.staffArray[indexPath.row]
        
        
            cell.textLabel?.text = staff.name
            return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(identifier: "StaffDetailViewController") as? StaffDetailViewController
        let staffSection : StaffSection = self.sections[indexPath.section]
        let staff : Staff = staffSection.staffArray[indexPath.row]
        vc?.staff = staff
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""
        {
           searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
            let groups = Dictionary(grouping: self.staffArray, by: {staff in staff.subject })
            self.sections = groups.map { (key, values) in
                return StaffSection(subject: key, staffArray: values.sorted { $0.name < $1.name })}
            self.sections = self.sections.sorted { $0.subject < $1.subject }
                     self.tableView.reloadData()
        }
        
        else {
            
            var filteredStaffArray = self.staffArray.filter({$0.name.lowercased().contains(searchText.lowercased())})
            let groups = Dictionary(grouping: filteredStaffArray, by: {staff in staff.subject })
            self.sections = groups.map { (key, values) in
                return StaffSection(subject: key, staffArray: values.sorted { $0.name < $1.name })
            }
            self.sections = self.sections.sorted { $0.subject < $1.subject }
                self.tableView.reloadData() }
       }
       
//       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//           searchBar.text = ""
//           self.tableView.reloadData()
//       }
//    


    func updateSearchResults(for searchController: UISearchController) {
        print("Searching with: " + (searchController.searchBar.text ?? ""))
        let searchText = (searchController.searchBar.text ?? "")

        
        
        if searchController.searchBar.text == nil || searchController.searchBar.text == ""
        {
            let groups = Dictionary(grouping: self.staffArray, by: {staff in staff.subject })
            self.sections = groups.map { (key, values) in
                return StaffSection(subject: key, staffArray: values.sorted { $0.name < $1.name })}
            self.sections = self.sections.sorted { $0.subject < $1.subject }
                     self.tableView.reloadData()
        }

        else {
            
            var filteredStaffArray = self.staffArray.filter({$0.name.lowercased().contains(searchText.lowercased())})
            let groups = Dictionary(grouping: filteredStaffArray, by: {staff in staff.subject })
            self.sections = groups.map { (key, values) in
                return StaffSection(subject: key, staffArray: values.sorted { $0.name < $1.name })
            }
            self.sections = self.sections.sorted { $0.subject < $1.subject }
                self.tableView.reloadData() }
        }
    


    

    
   
    
    
    
    
    
    
    func uploadToFirebase() {
        
        
        //English
        let RA = Staff.init(name: "Rich Ajlouny", website:[" ": "https://mrajlouny.weebly.com/"], email: "rajlouny@sjusd.org", subject: "English")
        let GB = Staff.init(name: "Gay Brasher", website:[" ":
            "http://lelandsdteam.weebly.com/"], email: "gbrasher@sjusd.org", subject: "English")
        let JC = Staff.init(name: "Jeannette Carmody", website:nil, email: "jcarmody@sjusd.org", subject: "English")
        let SD = Staff.init(name: "Stacy Dawson", website:nil, email: "sdawson@sjusd.org", subject: "English")
        let PG = Staff.init(name: "Priya Garcia", website:nil, email: "pgarcia@sjusd.org", subject: "English")
        let RJ = Staff.init(name: "Robin Jankowski", website:[ "APLang":"https://jankowskiaplanguage.weebly.com/"], email: "rjankowski@sjusd.org", subject: "English")
        let AL = Staff.init(name: "Annie Larks", website:nil, email: "alarks@sjusd.org", subject: "English")
        let EN = Staff.init(name: "Elaine Ngo", website:nil, email: "engo@sjusd.org", subject: "English")
        let SPeters = Staff.init(name: "Samantha Peters", website:[" ": "https://sites.google.com/sjusd.org/mspeters/home"], email: "speters@sjusd.org", subject: "English")
        let PS = Staff.init(name: "Patrick Soltz", website: [" ": "https://sites.google.com/site/stoltz10th/"], email: "psoltz@sjusd.org", subject: "English")
        let LT = Staff.init(name: "Liz Taylor", website:nil, email: "ltaylor@sjusd.org", subject: "English")
        let jTopalovic = Staff.init(name: "Jasmina Topalovic", website:nil, email: "jtopalovic@sjusd.org", subject: "English")
        let  jTouchton = Staff.init(name: "Jennifer Touchton", website: ["English 1-2": "https://sites.google.com/a/sjusd.org/touchton-english9/", "AP Lang": "https://sites.google.com/a/sjusd.org/touchton-ap-lang/"], email: "jtouchton@sjusd.org", subject: "English")
        let  MW = Staff.init(name: "Melissa Webb", website: ["English 1-2": "https://sites.google.com/a/sjusd.org/mrs-webb-english-1-2/home", "Honors 5-6": "https://sites.google.com/a/sjusd.org/mrs-webb-honors-5-6-english/", "Drama": "https://mwebb-drama.weebly.com/"], email: "mwebb@sjusd.org", subject: "English")
        //Foreign Language
        
        let  CB = Staff.init(name: "Chris Barros", website: ["French 1-2": "https://mrbarrosfrench1-2.blogspot.com/", "French 3-4": "https://barrosfrench3-4.blogspot.com/"], email: "cbarros.org", subject: "Foreign Language")
        let TB = Staff.init(name: "Tomas Blandino", website:nil, email: "tblandino@sjusd.org", subject: "Foreign Language")
        let AD = Staff.init(name: "Andrea Dashe", website: ["Spanish 1-2":"https://yearonespanish2019-2020.blogspot.com/", "Spanish 3-4":"https://yeartwospanish2019-2020.blogspot.com/"], email: "adashe@sjusd.org", subject: "Foreign Language")
        let RG = Staff.init(name: "Roberto Gutierrez", website:nil, email: "rgutierrez@sjusd.org", subject: "Foreign Language")
        let HH = Staff.init(name: "Heather Hendry", website: [" ":"https://new.edmodo.com/?go2url=%2Fhome"], email: "hhendry@sjusd.org", subject: "Foreign Language")
        let MM = Staff.init(name: "Mireille McNabb", website: [" ":"https://classroom.google.com/u/0/h"], email: "mmcnabb@sjusd.org", subject: "Foreign Language")
        let HP = Staff.init(name: "Heidi Pimentel", website:nil, email: "hpimentel@sjusd.org", subject: "Foreign Language")
        //Math
        let PN = Staff.init(name: "Phalguni Nandi", website:nil, email: "pnandi@sjusd.org", subject: "Math")
        let VB = Staff.init(name: "Veronica Burton", website: [" ":"https://vburton.weebly.com/"], email: "vburton@sjusd.org", subject: "Math")
        let MN = Staff.init(name: "Mallorie Nordahl", website: [" ":"http://thecarucciclass.weebly.com/"], email: "mnordahl@sjusd.org", subject: "Math")
        let JF = Staff.init(name: "Jeffrey Chen", website:nil, email: "jchen@sjusd.org", subject: "Math")
        let GC = Staff.init(name: "Gary Clarke", website: [" ":"https://sites.google.com/sjusd.org/lelandclarkemath/"], email: "gclarke@sjusd.org", subject: "Math")
        let TH = Staff.init(name: "Tracy Hall", website: [" ":"https://mrshallteachesmath.weebly.com/"], email: "thall@sjusd.org", subject: "Math")
        let JL = Staff.init(name: "Jeff Lutze", website: [" ":"https://jlutze.weebly.com/"], email: "jlutze@sjusd.org", subject: "Math")
        let JMont = Staff.init(name: "Julia Montgomery", website: [" ":"https://mathwithmsmontgomery.weebly.com/"], email: "jmontgomery@sjusd.org", subject: "Math")
        let LP = Staff.init(name: "Leila Park", website:nil, email: "lpark@sjusd.org", subject: "Math")
        let KThoman = Staff.init(name: "Katrina Thoman", website: [" ":"https://mrskatthoman.weebly.com/"], email: "kthoman@sjusd.org", subject: "Math")
        let WY = Staff.init(name: "Wilson Yen", website: [" ":"https://wilsonyen.weebly.com/"], email: "wyen@sjusd.org", subject: "Math")
        let SY = Staff.init(name: "Susanna Young", website: [" ":"http://mrsyoungsmathclasses.weebly.com/"], email: "syoung@sjusd.org", subject: "Math")
        //PE
        let KD = Staff.init(name: "Kelly Dybdahl", website: nil, email: "kdybdahl@sjusd.org", subject: "PE")
        let MG = Staff.init(name: "Michael Gray", website: nil, email: "mgray@sjusd.org", subject: "PE")
        let PH = Staff.init(name: "Pam Headley", website: nil, email: "pheadley@sjusd.org", subject: "PE")
        let RP = Staff.init(name: "Robert Peng", website: nil, email: "rpeng@sjusd.org", subject: "PE")
        //Science
        let HA = Staff.init(name: "Helen Arrington", website: nil, email: "harrington@sjusd.org", subject: "Science")
        let GA = Staff.init(name: "Greg Asplund", website: nil, email: "gasplund@sjusd.org", subject: "Science")
        let MC = Staff.init(name: "Mark Cahn", website: [" ":"https://sites.google.com/view/mr-cahn-leland-high-school/home?authuser=1"], email: "mcahn@sjusd.org", subject: "Science")
        let DHall = Staff.init(name: "David Hall", website:nil, email: "dhall@sjusd.org", subject: "Science")
        let SL = Staff.init(name: "Sarah Lofgren", website:nil, email: "slofgren@sjusd.org", subject: "Science")
        let JO = Staff.init(name: "Jennifer Oddson", website: [" ":"https://sites.google.com/sjusd.org/oddychemistry/home"], email: "joddson@sjusd.org", subject: "Science")
        let JP = Staff.init(name: "Jessica Paulsen", website: [" ":"https://sites.google.com/sjusd.org/lelandsciencepaulsen/home"], email: "jpaulsen@sjusd.org", subject: "Science")
        let SRivera = Staff.init(name: "Samuel Rivera", website: ["Biology ":"https://sites.google.com/site/riverasbiology1/", "AP Environmental Science": "https://sites.google.com/site/lelandapes/home", "Chemistry": "https://sites.google.com/sjusd.org/riveras-chemistry"], email: "srivera@sjusd.org", subject: "Science")
        let AS = Staff.init(name: "Anu Sarkar", website: [" ": "https://sites.google.com/site/anusarkar02/home"], email: "asarkar@sjusd.org", subject: "Science")
        let JS = Staff.init(name: "Jeffry Sloneker", website: nil, email: "jsloneker@sjusd.org", subject: "Science")
        let KTibbs = Staff.init(name: "Kevin Tibbs", website: nil, email: "ktibbss@sjusd.org", subject: "Science")
        let RW = Staff.init(name: "Rob Wallace", website: nil, email: "rwallace@sjusd.org", subject: "Science")
        let LW = Staff.init(name: "Lon Walton", website: nil, email: "lwalton@sjusd.org", subject: "Science")
        // Social Science
        let CB_SS = Staff.init(name: "Chris Barros", website: [" ": "https://barrosaccelworldhistory.blogspot.com/"], email: "cbarros@sjusd.org", subject: "Social Science")
        let JCanter = Staff.init(name: "Jeff Canter", website: nil, email: "jcanter@sjusd.org", subject: "Social Science")
        let JCohen = Staff.init(name: "Jamie Cohen", website: ["US History": "https://cohenush.blogspot.com/", "AP Capstone":"https://cohencap.blogspot.com/", "US Goverment and Economics": "https://cohengovecon.blogspot.com/"], email: "jcohen@sjusd.org", subject: "Social Science")
        let TC = Staff.init(name: "Trisha Connors", website: ["AP Goverment": "https://connorsapgov.blogspot.com/", "US Goverment and Economics":"https://cohengovecon.blogspot.com/"], email: "tconnors@sjusd.org", subject: "Social Science")
        let SG = Staff.init(name: "Scot Gillis", website: ["World Cultures": "https://sites.google.com/sjusd.org/lelandgilliswc/home", "World History ":"https://sites.google.com/sjusd.org/lelandgilliswc/home"], email: "sgillis@sjusd.org", subject: "Social Science")
        let DHilger = Staff.init(name: "David Hilger", website: nil, email: "dhilger@sjusd.org", subject: "Social Science")
        let JK = Staff.init(name: "Joe Kerwin", website: [" ": "https://lelandkerwin.blogspot.com/"], email: "jkerwin@sjusd.org", subject: "Social Science")
        let BM = Staff.init(name: "Brian Marchetti", website: ["US History": "https://marchettiushistory.blogspot.com/", "World Cultures":"https://marchettiworld.blogspot.com/", "AP US History": "https://marchettiapush.blogspot.com/"], email: "bmarchetti@sjusd.org", subject: "Social Science")
        let RM = Staff.init(name: "Rob Miller", website: nil, email: "rmiller@sjusd.org",subject: "Social Science")
        let JMoura = Staff.init(name: "Joe Moura", website: nil, email: "jmoura@sjusd.org",subject: "Social Science")
        let SPaul = Staff.init(name: "Suzanne Paulazzo", website: ["AP Euro": "https://paulazzoapeh.blogspot.com/", "World Cultures":"https://marchettiworld.blogspot.com/", "AP Goverment/Economics": "https://paulazzoapgovecon.blogspot.com/", "Goverment and Economics":"https://paulazzogovecon.blogspot.com/"], email: "spaulazzo@sjusd.org", subject: "Social Science")
        let SS = Staff.init(name: "Steve Seandel", website: ["US History": "https://seandelushistory.blogspot.com/", "AP US History":"https://seandelapush.blogspot.com/%E2%80%8B"], email: "sseandel@sjusd.org", subject: "Social Science")
        //visual Performing Arts
        let CD = Staff.init(name: "Cydney Debenedetto", website: [" ": "http://cydneyd.weebly.com/"], email: "cdebenedetto@sjusd.org",subject: "Visual Peforming Arts")
        let NH = Staff.init(name: "Neil Hamilton", website: [" ": "https://sites.google.com/sjusd.org/lelandsculpts/home"], email: "nhamilton@sjusd.org",subject: "Visual Peforming Arts")
        let DM = Staff.init(name: "Darla McKenna", website: [" ": "https://sites.google.com/sjusd.org/teacher-ms-mckenna/home"], email: "dmckenna@sjusd.org",subject: "Visual Peforming Arts")
        let SRap = Staff.init(name: "Stacy Rapoport", website: [" ": "https://sites.google.com/a/sjusd.org/lhs-rapoport/"], email: "srapoport@sjusd.org",subject: "Visual Peforming Arts")
        let RR = Staff.init(name: "Rian Rodriguez", website: nil, email: "rrodriguez@sjusd.org",subject: "Visual Peforming Arts")
        let AR = Staff.init(name: "Alison Rutsch", website: [" ": "https://cargocollective.com/rutsch"], email: "rrodriguez@sjusd.org",subject: "Visual Peforming Arts")
        
        
        // create a staff array
        let staffArray: [Staff] = [RA,GB,JC,SD,PG,RJ,AL,EN,SPeters,PS,LT,jTouchton,jTopalovic,HH,HP, MW, CB, TB, AD,RG,MM,PN,VB,MN,JF,GC,TH,JL,JMont,LP,KThoman,WY,SY,KD,MG,PH,RP,HA,GA,MC,DHall,SL,JO,JP,SRivera,AS,JS,KTibbs,RW,LW,CB_SS,JCanter,JCohen,TC,SG,DHilger,JK,BM,RM,JMoura,SPaul,SS,CD,NH,DM,SRap,RR,AR]
        
        
        for staff in staffArray {
            var ref: DocumentReference? = nil
            ref = db.collection("staff").addDocument(data: [
                "name": staff.name,
                "website": staff.website,
                "email": staff.email,
                "subject": staff.subject
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
}

