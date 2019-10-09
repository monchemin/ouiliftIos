//
//  BaseApi.swift
//  ouilift
//
//  Created by Mewena on 2019-07-27.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import Foundation

class BaseAPI<T: Codable> {
    let baseEndpoint = "http://api-test.toncopilote.com/"
    var endpoint: String
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func get (completion: @escaping ([T]) -> Void) {
        guard let url = URL(string: baseEndpoint+endpoint) else {
            print("Error: cannot create URL")
            return
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
                        if let TResponses: [T] = try? JSONDecoder().decode([T].self, from: jsonData) {
                            completion(TResponses)
                        }
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func post (TRequest: T, completion: @escaping (Int) -> Void) {
        guard let url = URL(string: baseEndpoint+endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let jsonData = try? JSONEncoder().encode(TRequest)
        urlRequest.httpBody = jsonData
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling POST")
                print(error!)
                return
            }
            
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                {
                    if let TStatus = json["status"] as? Int {
                        completion(TStatus)
                    }
                }
                
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        task.resume()
    }
    
}
