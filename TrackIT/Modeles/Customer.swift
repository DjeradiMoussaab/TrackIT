//
//  Customer.swift
//  TrackIT
//
//  Created by Mac on 11/16/19.
//  Copyright © 2019 mossab. All rights reserved.
//

import Foundation
class Customer: Decodable {
    let email: String
    let name: String
    let phone: String
    let target: String
    let customerId: String
    
    init(email: String, name: String, phone: String, target: String, customerId: String) {
        self.email = email
        self.name = name
        self.phone = phone
        self.target = target
        self.customerId = customerId
    }
}


class Customers: Decodable {
    let customers : Customer
    init(customers: Customer) {
        self.customers = customers
    }
}
