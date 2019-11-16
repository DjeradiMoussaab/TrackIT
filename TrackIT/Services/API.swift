//
//  API.swift
//  TrackIT
//
//  Created by Mac on 11/15/19.
//  Copyright © 2019 mossab. All rights reserved.
//

import Foundation
import SwiftyJSON

class API {
    static let APIInstance = API()
    
    func GetLuggages(customerID: String,onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = BASE_URL + "baggage?customerId=\(customerID)"
        //url = "https://demo6909855.mockable.io/baggage"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.setValue("jmdSHjy6WPaXwoR75E6mJ1ImhxKPRJb51v6DBS0A", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if (error != nil){
                onFailure(error!)
            } else {
                onSuccess(data!)
            }
        })
        task.resume()
    }
    
    func GetEvents(baggageID: String,onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = BASE_URL + "events/\(baggageID)"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.setValue("jmdSHjy6WPaXwoR75E6mJ1ImhxKPRJb51v6DBS0A", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if (error != nil){
                onFailure(error!)
            } else {
                onSuccess(data!)
            }
        })
        task.resume()
    }
    
    func GetCustomer(customerID: String,onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = BASE_URL + "customers?customerId=\(customerID)"
        print(url)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.setValue("jmdSHjy6WPaXwoR75E6mJ1ImhxKPRJb51v6DBS0A", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if (error != nil){
                onFailure(error!)
            } else {
                onSuccess(data!)
            }
        })
        task.resume()
    }
    
    func GetLocation(airportName: String,onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = "https://airport-info.p.rapidapi.com/airport?iata=\(airportName)"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.setValue("airport-info.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue("8dc44f226cmsh847ac199aff47f4p119689jsn50e49820b42d", forHTTPHeaderField: "x-rapidapi-key")
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if (error != nil){
                onFailure(error!)
            } else {
                onSuccess(data!)
            }
        })
        task.resume()
    }
    
}
