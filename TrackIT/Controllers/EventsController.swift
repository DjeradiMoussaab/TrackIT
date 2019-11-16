//
//  EventsController.swift
//  TrackIT
//
//  Created by Mac on 11/16/19.
//  Copyright © 2019 mossab. All rights reserved.
//

class EventsCell: UITableViewCell  {
    @IBOutlet weak var eventSquare: UIImageView!
    @IBOutlet weak var eventLine: UIImageView!
    @IBOutlet weak var eventDetails: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        self.eventSquare.backgroundColor = UIColor.lightGray
        self.backgroundColor = UIColor.white
        self.eventLine.isHidden = false
    }
}

import UIKit

class EventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var luggageIcon: UIImageView!
    @IBOutlet weak var eventsTableView: UITableView!
    var EventsJSON: EventsArray?
    var baggageID: String = ""
    var luggageIconString: String = ""
    @IBOutlet weak var luggageIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsTableView.delegate = self
        self.eventsTableView.dataSource = self
        self.getEvents(baggageID: baggageID)
        self.luggageIcon.image = UIImage(named: luggageIconString)
        self.luggageIDLabel.text = "Luggage ID: #\(self.adjustBaggageID(date: self.baggageID))"
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( self.EventsJSON != nil ) {
            return EventsJSON!.events.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as! EventsCell
        cell.eventDetails.text = "Your Luggage was \(EventsJSON!.events[indexPath.row].type) at \(EventsJSON!.events[indexPath.row].airport)"
        cell.eventDate.text = "\(adjustDateString(date: EventsJSON!.events[indexPath.row].timestamp)), \(adjustTimeString(date: EventsJSON!.events[indexPath.row].timestamp))"
        cell.layer.cornerRadius = 10.0
        if ( EventsJSON!.events[indexPath.row].type == "MISSING" || EventsJSON!.events[indexPath.row].type == "DAMAGED") {
            cell.eventSquare.backgroundColor = UIColor.red
            cell.backgroundColor = UIColor(red:1.00, green:0.96, blue:0.96, alpha:1.0)
        } else if ( EventsJSON!.events[indexPath.row].type == "CLAIMED" ) {
            cell.eventSquare.backgroundColor = UIColor.green
            cell.backgroundColor = UIColor(red:0.96, green:0.99, blue:0.96, alpha:1.0)
        }
        if ( indexPath.row == (EventsJSON?.events.count)!-1 ) {
            cell.eventLine.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func adjustDateString(date: String)-> String {
        var newDate: String = ""
        newDate = String(date.prefix(10))
        return newDate
    }
    
    func adjustBaggageID(date: String)-> String {
        var newDate: String = ""
        newDate = String(date.suffix(12))
        return newDate
    }
    
    func adjustTimeString(date: String)-> String {
        var newDate: String = ""
        newDate = String(date.prefix(16))
        newDate = String(newDate.suffix(5))
        return newDate
    }
    
    func getEvents(baggageID: String) {
        if (self.EventsJSON == nil) {
            API.APIInstance.GetEvents(baggageID: baggageID, onSuccess: { data in
                let decoder = JSONDecoder()
                self.EventsJSON = try? decoder.decode(EventsArray.self, from: data)
                DispatchQueue.main.async {
                    print("-------> \(self.EventsJSON!.events.count)")
                    self.eventsTableView.reloadData()
                }
            }, onFailure: { error in
                print(error)
            })
        }
    }
    

}
