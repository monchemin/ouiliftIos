//
//  AddRouteViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-12-15.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class AddRouteViewController: UIViewController, UITextFieldDelegate {
    
    var defaulValue: String = ""
    
    var isFromClicked: Bool?
    
    @IBOutlet weak var carBrandAndModel: UITextField!
    
    @IBOutlet weak var routeDateTime: UIDatePicker!
    
    @IBOutlet weak var routeFromStatation: UITextField!
    
    @IBOutlet weak var routeToStation: UITextField!
    
    @IBOutlet weak var routePlace: UITextField!
    
    @IBOutlet weak var routePrice: UITextField!
    
    
    @IBAction func carAction(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToCustomerCarViewController", sender: nil)
    }
    
    @IBAction func routeDateTimeAction(_ sender: Any) {
        OuiLiftTabBarController.routeDateTime = routeDateTime.date
    }
    
    @IBAction func fromStationAction(_ sender: Any) {
        //segueAddRouteToStationController
    }
    
    @IBAction func toStatationAction(_ sender: Any) {
    }
    
    @IBAction func addRouteAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        routePlace.delegate = self
        routePrice.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        carBrandAndModel?.text = OuiLiftTabBarController.carBrandAndModel ?? defaulValue
        routeDateTime.date = OuiLiftTabBarController.routeDateTime ?? routeDateTime.date
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
