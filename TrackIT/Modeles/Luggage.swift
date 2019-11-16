//
//  Luggage.swift
//  TrackIT
//
//  Created by Mac on 11/15/19.
//  Copyright © 2019 mossab. All rights reserved.
//

class Luggage: Decodable {
    let baggageId: String
    let special: String
    let rushbag: String
    let weight: Float
    let customerId: String
    
    init(baggageId: String, special: String, rushbag: String, weight: Float, customerId: String) {
        self.baggageId = baggageId
        self.special = special
        self.rushbag = rushbag
        self.weight = weight
        self.customerId = customerId
    }
}

class LuggagesArray: Decodable {
    let baggage : Array<Luggage>
    init(baggage: Array<Luggage>) {
        self.baggage = baggage
    }
}

