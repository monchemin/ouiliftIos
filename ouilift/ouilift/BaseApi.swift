//
//  BaseApi.swift
//  ouilift
//
//  Created by Mewena on 2019-07-27.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import Foundation

class BaseAPI<T: Codable> {
    var baseEndpoint = "http://api-test.toncopilote.com/"
    
    func get (endpoint: String) -> [T] {
        var getTs: [T] = []
        let endpoint = baseEndpoint+endpoint
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return []
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let responses = json["response"] as? [Any] {
                    let jsonData = try? JSONSerialization.data(withJSONObject:responses)
                    if let jsonData = jsonData {
                        if let totos: [T] = try? JSONDecoder().decode([T].self, from: jsonData) {
                            getTs = totos
                        }
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        task.resume()
        return getTs
    }
}
