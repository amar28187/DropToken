//
//  GameService.swift
//  DropToken
//
//  Created by Amar Makana on 5/19/21.
//

import Foundation

typealias Turns = [Int]
let url = "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production"

class GameService {
    static let session = URLSession.shared
    
    static func play(turns: Turns, completion: @escaping (Turns?) -> Void) {
        
        /// Construct base URL
        guard var comp = URLComponents(string: url) else{
            completion(nil)
            return
        }
        
        /// Build query
        comp.query = "moves=" + "\(turns)"
        
        /// Get final URL
        guard let url = comp.url else {
            completion(nil)
            return
        }
        
        print("url: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) { data, response, error in
            if let d = data {
                guard let json = try? JSONSerialization.jsonObject(with: d) else {
                    completion(nil)
                    return
                }
                print(json)

                guard let array = json as? Turns else {
                    completion(nil)
                    return
                }
                
                completion(array)
            } else if let resp = response as? HTTPURLResponse, resp.statusCode == 400 { // Check on response code 400
                completion(nil) // Bad request
            } else {
                completion(nil)
            }
            
        }
        
        /// Start task
        task.resume()
        
    }
}
