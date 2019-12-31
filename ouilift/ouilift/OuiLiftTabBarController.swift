//
//  OuiLiftTabBarController.swift
//  ouilift
//
//  Created by Mewena on 2019-10-12.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class OuiLiftTabBarController: UITabBarController {
    
    struct Customer: Codable {
        var Id: String?
        var firstName: String?
        var lastName: String?
        var phoneNumber: String?
        var eMail: String?
        var password: String?
        var createdAt: String?
        var drivingNumber: String?
        var activationCode: String?
        var active: String?
        
        init (_ customerKP: String, _ customerFistName: String, _ customerLastName: String, _ customerPhoneNumber: String, _ customerEMailAddress: String, _ customerPassword: String, _ customerCreatedAt: String, _ customerDrivingNumber: String, _ customerActivationCode: String, _ customerActive: String) {
            self.Id = customerKP
            self.firstName = customerFistName
            self.lastName = customerLastName
            self.phoneNumber = customerPhoneNumber
            self.eMail = customerEMailAddress
            self.password = customerPassword
            self.createdAt = customerCreatedAt
            self.drivingNumber = customerDrivingNumber
            self.activationCode = customerActivationCode
            self.active = customerActive
        }
    }
    
    static var connectedCustomer: Customer?
    
    static var fromStationId: String?
    
    static var formStationName: String?
    
    static var toStationId: String?
    
    static var toStationName: String?
    
    static var stationDate: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
