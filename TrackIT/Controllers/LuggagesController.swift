//
//  LuggagesController.swift
//  TrackIT
//
//  Created by Mac on 11/15/19.
//  Copyright © 2019 mossab. All rights reserved.
//

import UIKit

class LuggagesCell: UITableViewCell  {
    @IBOutlet weak var luggageStatus: UILabel!
    @IBOutlet weak var luggageType: UILabel!
    @IBOutlet weak var luggageWeight: UILabel!
    @IBOutlet weak var luggageID: UILabel!
    @IBOutlet weak var luggageIcon: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

class LuggagesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var destinationIndicator: UIActivityIndicatorView!
    @IBOutlet weak var departureIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var depature: UILabel!
    @IBOutlet weak var destination: UILabel!
    var LuggagesJSON: LuggagesArray?
    var EventsJSON: EventsArray?
    var CustomerJSON: Customers?
    var LuggagesStatus: [String: String] = [:]
    var i = 0
    //var customerID: String = "9a55a8c6-5da0-4ac1-8527-dad2776c6db6"
    var customerID: String = ""
    @IBOutlet weak var luggagesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tabBarController?.tabBar.tintColor = UIColor.yellow

        self.depature.isHidden = true
        self.destination.isHidden = true
        self.luggagesTableView.isHidden = true
        self.departureIndicator.startAnimating()
        self.destinationIndicator.startAnimating()
        self.tableViewIndicator.startAnimating()
        
        self.luggagesTableView.delegate = self
        self.luggagesTableView.dataSource = self
        self.getLuggages()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( self.LuggagesJSON != nil ) {
            return LuggagesJSON!.baggage.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LuggagesCell", for: indexPath) as! LuggagesCell
        cell.luggageID.text = "Luggage ID: #\(adjustBaggageID(date: LuggagesJSON!.baggage[indexPath.row].baggageId))"
        cell.luggageWeight.text = "Weight: \(LuggagesJSON!.baggage[indexPath.row].weight)Kg"
        let LuggageTypeString = DecodeLuggageType(Code: LuggagesJSON!.baggage[indexPath.row].special)
        cell.luggageType.text = "Luggage type: \(LuggageTypeString)"
        var statusColor: UIColor = UIColor.darkGray
        if ( LuggagesStatus.count > indexPath.row ) {
            statusColor = DecodeLuggageStatusColor(Code: LuggagesStatus["\(LuggagesJSON!.baggage[indexPath.row].baggageId)"]!)
            cell.luggageStatus.text = "\(LuggagesStatus[LuggagesJSON!.baggage[indexPath.row].baggageId] ?? "NOT FOUND")"
            cell.luggageStatus.textColor = statusColor
        } else {
            cell.luggageStatus.text = "NOT FOUND"
            cell.luggageStatus.textColor = statusColor
        }
        cell.luggageIcon.image = UIImage(named: "\(LuggageTypeString)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let LuggageTypeString = DecodeLuggageType(Code: LuggagesJSON!.baggage[indexPath.row].special)
        self.ChangeScreen(imageString: LuggageTypeString,baggageID: LuggagesJSON!.baggage[indexPath.row].baggageId)
    }
    
    func adjustBaggageID(date: String)-> String {
        var newDate: String = ""
        newDate = String(date.suffix(12))
        return newDate
    }
    
    func DecodeLuggageType(Code:String) -> String {
        if ( Code.prefix(1) == "N" ) { return "Normal"}
        if ( Code.prefix(1) == "A" ) { return "Animal" }
        if ( Code.prefix(1) == "L" ) { return "Long baggage" }
        if ( Code.prefix(1) == "H" ) { return "Heavy baggage" }
        if ( Code.prefix(1) == "C" ) { return "Special condition" }
        if ( Code.prefix(1) == "T" ) { return "Toxic chemicals" }
        if ( Code.prefix(1) == "W" ) { return "Weapons or ammunition" }
        return ""
    }
    
    func DecodeLuggageStatusColor(Code:String) -> UIColor {
        if ( Code == "DAMAGED" || Code == "MISSING" ) { return UIColor.red }
        if ( Code == "CLAIMED" ) { return UIColor.green }
        return UIColor.darkGray
    }
    
    
    func getLuggages() {
        //self.customerID = "9a55a8c6-5da0-4ac1-8527-dad2776c6db6"
        if (self.LuggagesJSON == nil) {
            API.APIInstance.GetLuggages(customerID: self.customerID, onSuccess: { data in
                let decoder = JSONDecoder()
                self.LuggagesJSON = try? decoder.decode(LuggagesArray.self, from: data)
                DispatchQueue.main.async {
                    self.getEvents(baggageID: self.LuggagesJSON!.baggage[self.i].baggageId)
                }
            }, onFailure: { error in
                print(error)
            })
        }
    }
    
    func getEvents(baggageID: String) {
       // if (self.EventsJSON == nil) {
            API.APIInstance.GetEvents(baggageID: baggageID, onSuccess: { data in
                let decoder = JSONDecoder()
                self.EventsJSON = try? decoder.decode(EventsArray.self, from: data)
                DispatchQueue.main.async {
                    let count = self.EventsJSON!.events.count
                    if ( count != 0 ) {
                        if ( self.i == 0 ) {
                            self.departureIndicator.stopAnimating()
                            self.departureIndicator.isHidden = true
                            self.depature.isHidden = false
                            self.depature.text = self.EventsJSON!.events[0].airport
                            self.GetCustomer(customerID: self.customerID)
                        }
                        print("got \(self.EventsJSON!.events[0].airport)")
                        self.LuggagesStatus.updateValue(self.EventsJSON!.events[count-1].type, forKey: baggageID)
                    }
                    self.i = self.i + 1
                    if ( self.LuggagesJSON!.baggage.count == self.i ) {
                        self.tableViewIndicator.stopAnimating()
                        self.tableViewIndicator.isHidden = true
                        self.luggagesTableView.isHidden = false
                        self.luggagesTableView.reloadData()
                    } else {
                        self.getEvents(baggageID: self.LuggagesJSON!.baggage[self.i].baggageId)
                    }
                }
            }, onFailure: { error in
                print(error)
            })
       // }
    }
    
    func ChangeScreen(imageString: String, baggageID: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let EventsController = storyBoard.instantiateViewController(withIdentifier: "EventsController") as! EventsController
        EventsController.baggageID = baggageID
        EventsController.luggageIconString = imageString
        self.navigationController?.pushViewController(EventsController, animated: true)
    }
    
    func GetCustomer(customerID: String) {
        self.customerID = "9a55a8c6-5da0-4ac1-8527-dad2776c6db6"
        if (self.CustomerJSON == nil) {
            API.APIInstance.GetCustomer(customerID: self.customerID, onSuccess: { data in
                let decoder = JSONDecoder()
                self.CustomerJSON = try? decoder.decode(Customers.self, from: data)
                DispatchQueue.main.async {
                    self.destinationIndicator.stopAnimating()
                    self.destinationIndicator.isHidden = true
                    self.destination.isHidden = false
                    self.destination.text = self.CustomerJSON!.customers.target
                }
            }, onFailure: { error in
                print(error)
            })
        }
    }
    


}
