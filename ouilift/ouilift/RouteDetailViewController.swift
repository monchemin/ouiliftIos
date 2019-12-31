//
//  RouteDetailViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-09-14.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class RouteDetailViewController: UIViewController, UITextFieldDelegate {
    
    var routeId: String?
    var detailDate: String?
    var detailPrice: String?
    var detailRemainingPlace: String?
    var detailHour: String?
    var detailFStation: String?
    var detailFStationDetails: String?
    var detailTStation: String?
    var detailTStationDetails: String?
    var defaulValue: String = ""
   
    @IBOutlet weak var routeDetailDateHeure: UILabel!
    
    @IBOutlet weak var routeDetailFrom: UILabel!
    
    @IBOutlet weak var routeDetailTo: UILabel!
    
    @IBOutlet weak var routeDetailPrice: UILabel!
    
    @IBOutlet weak var routeDetailPlace: UILabel!
    
    @IBOutlet weak var routeDetailFromDetails: UILabel!
    
    @IBOutlet weak var routeDetailToDetails: UILabel!
    
    @IBOutlet weak var routeDetailPlaceToReserve: UITextField!
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    @IBAction func reservationAction(_ sender: Any) {
        if (OuiLiftTabBarController.connectedCustomer != nil) {
            let customerId = OuiLiftTabBarController.connectedCustomer?.Id
            let reservationApi = BaseAPI<CreateAccountViewController.Reservation>(endpoint: "reservations.php")
            let reservation = CreateAccountViewController.Reservation(customerId!, self.routeId!, self.detailRemainingPlace!, true)
            reservationApi.post(TRequest: reservation, completion: { (status) in
                if (status == 200) {
                    
                    DispatchQueue.main.async {
                        self.showAlert(message: "Confirmation de votre enregistrement")
                        //toDo : revenir a ecran de recherche de route
                        // self.performSegue(withIdentifier: "segueToCreateAccount", sender: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                    }
                }
            })
            
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "segueToCreateAccount", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        routeDetailPlaceToReserve.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        routeDetailDateHeure.text = "Départ le \(detailDate ?? defaulValue) à \(detailHour ?? defaulValue)"
        routeDetailFrom.text = "De: \(detailFStation ?? defaulValue)"
        routeDetailFromDetails.text = detailFStationDetails ?? defaulValue
        routeDetailTo.text = "À: \(detailTStation ?? defaulValue)"
        routeDetailToDetails.text = detailTStationDetails ?? defaulValue
        routeDetailPrice.text =  detailPrice ?? defaulValue
        routeDetailPlace.text = "\(detailRemainingPlace ?? defaulValue) Place(s)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToCreateAccount") {
            let createAccountVC = segue.destination as! CreateAccountViewController
            createAccountVC.routeId = routeId
            createAccountVC.place = routeDetailPlaceToReserve.text
            createAccountVC.price = detailPrice
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Oui Lift", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: false, completion: nil)
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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

}
