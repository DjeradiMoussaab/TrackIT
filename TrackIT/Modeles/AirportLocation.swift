//
//  Luggage.swift
//  TrackIT
//
//  Copyright © 2019 mossab. All rights reserved.
//

class AirportLocation: Decodable {
    let latitude: Double
    let longitude: Double
    let name: String
    
    init( latitude: Double,
     longitude: Double,
     name: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }

}

class AirportLocationArray: Decodable {
    let locations : Array<AirportLocation>
    init(location: Array<AirportLocation>) {
        self.locations = location
    }
}


