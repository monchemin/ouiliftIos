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
    
    static var fromStationName: String?
    
    static var toStationId: String?
    
    static var toStationName: String?
    
    static var stationDate: String?
    
    static var carBrandAndModel: String?
    
    static var carBrandAndModelId: String?
    
    static var routeDateTime: Date?
    
    static var routeFromStationId: String?
    
    static var routeFromStationName: String?
    
    static var routeToStationId: String?
    
    static var routeToStationName: String?
    
    // static var routePickupHour: String?
    
    static var menuItems: [UITabBarItem]?
    
    static func initSearchRouteField(){
        fromStationId = nil
        fromStationName = nil
        toStationId = nil
        toStationName = nil
        stationDate = nil
    }
    
    static func initRouteField(){
        routeDateTime = nil
        routeFromStationId = nil
        routeFromStationName = nil
        routeToStationId = nil
        routeToStationName = nil
        carBrandAndModelId = nil
        carBrandAndModel = nil
    }
    
    
    static func manageTabBarMenus() {
        if (OuiLiftTabBarController.connectedCustomer == nil){
            OuiLiftTabBarController.menuItems![1].isEnabled = false
            OuiLiftTabBarController.menuItems![2].isEnabled = false
            OuiLiftTabBarController.menuItems![3].isEnabled = false
        } else {
            OuiLiftTabBarController.menuItems![1].isEnabled = true
            OuiLiftTabBarController.menuItems![2].isEnabled = true
            OuiLiftTabBarController.menuItems![3].isEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        OuiLiftTabBarController.menuItems = self.tabBar.items!
        OuiLiftTabBarController.manageTabBarMenus()

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
