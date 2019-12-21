//
//  Requester.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/21/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import Foundation

fileprivate struct FSQKeys {
    static let CLIENT_ID = "X1AN0BZQ4SP34FT0HVACAIHVITXURUDVX4T5R12VTVFU5ZU3"
    static let CLIENT_SECRET = "N5HZJENFLZR1UZNCCZVD0B1IB22ILD3W00KDYBCUP3EGACCH"
}

fileprivate struct FSQUrler {
    static let baseURL = "https://api.foursquare.com"
    
    static let trendingVenuesEndpoint = "/v2/venues/trending"
    
    static func trendingVenuesURL(limit: Int, radius: Int, long: Double, lat: Double)->URL? {
        var urlString = baseURL + trendingVenuesEndpoint
        let auth = authParams()
        let v = versionParam()
        let limit = param(withKey: "limit", andValue: String(limit))
        let radius = param(withKey: "radius", andValue: String(radius))
        let ll = param(withKey: "ll", andValue: String(lat)+","+String(long))
        urlString.append("?"+auth+"&"+limit+"&"+radius+"&"+ll+"&"+v)
        return URL(string: urlString)
    }
    
    static func authParams()->String {
        let cid = param(withKey: "client_id", andValue: FSQKeys.CLIENT_ID)
        let cs = param(withKey: "client_secret", andValue: FSQKeys.CLIENT_SECRET)
        return cid+"&"+cs
    }
    
    static func versionParam()->String {
        return param(withKey: "v", andValue: "20191219")
    }
    
    static func param(withKey key: String, andValue value: String)->String {
        return key+"="+value
    }
}

class FSQRequester: NSObject, NSURLConnectionDelegate {
    func requestTrendingVenues(longitude: Double, latitude: Double, radius: Int = 99999, limit: Int = 5, completion: @escaping ([Venue]?)->Void) {

        if let url = FSQUrler.trendingVenuesURL(limit: limit, radius: radius, long: longitude, lat: latitude) {
            let request = URLRequest(url:url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let _ = error {
                   completion(nil)
                }
                else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        let venues = self.parseJSON(json: json)
                        completion(venues)
                    }
                }
                else {
                    completion(nil)
                }
            }
            task.resume()
            
        }
        else {
            completion(nil)
            print("Invalid Request URL")
        }
    }
    
    private func parseJSON(json: Any)->[Venue]? {
        var parsedVenues = [Venue]()
        
        if let json = json as? [String: Any], let response = json["response"] as? [String:Any], let venues = response["venues"] as? [[String: Any]]  {
            for vDict in venues {
                if let vId = vDict["id"] as? String,
                    let name = vDict["name"] as? String,
                    let locationDict = vDict["location"] as? [String: Any],
                    let address = locationDict["address"] as? String,
                    let distance = locationDict["distance"] as? Int64,
                    let categoryDict = (vDict["categories"] as? [[String: Any]])?.first,
                    let category = categoryDict["shortName"] as? String
                {
                    let venue = Manager.shared.venueWithInfo(fqId: vId, name: name, address: address, category: category, distance: distance)
                    parsedVenues.append(venue)
                }
                else {
                    return nil
                }
            }
        }
        else {
            print("Invalid json")
            return nil
        }
        
        return parsedVenues
    }
}
