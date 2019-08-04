//
//  BrandApi.swift
//  ouilift
//
//  Created by Mewena on 2019-07-27.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

//toDo : implementer une interface qui forme à avpir les implementations de REST
//toDo : heriter d'un baseApi qui va contenir le baseEndPoint
import Foundation

class BrandApi {
    
    struct Brand {
        let brandName: String
        
    }
    
    static func getBrands () -> [Brand] {
        let brandEndpoint = "http://autoexpress.gabways.com/api/carBrand.php"
        guard let url = URL(string: brandEndpoint) else {
            print("Error: cannot create URL")
            return []
        }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            print (responseData)
        }
        task.resume()
        
        let brands = [Brand(brandName: "")]
        
        return brands
    }
}
