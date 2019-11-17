//
//  Event.swift
//  TrackIT
//
//  Created by Mac on 11/16/19.
//  Copyright © 2019 mossab. All rights reserved.
//

import Foundation
class Event: Decodable {
    let baggageId: String
    let eventId: String
    let type: String
    let airport: String
    let timestamp: String
    
    init(baggageId: String, eventId: String, type: String, airport: String, timestamp: String) {
        self.baggageId = baggageId
        self.eventId = eventId
        self.type = type
        self.airport = airport
        self.timestamp = timestamp
    }
}


class EventsArray: Decodable {
    let events : Array<Event>
    init(events: Array<Event>) {
        self.events = events
    }
}
