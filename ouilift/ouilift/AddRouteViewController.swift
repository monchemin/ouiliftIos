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
    
    struct Route: Codable {
        var customerId: String
        var price: String
        var place: String
        var date: String
        var hour: String
        var departure: String
        var arrival: String
        var car: String
        
        init (_ customerId: String, _ price: String, _ place: String, _ date: String, _ hour: String, _ departure: String, _ arrival: String, _ car: String) {
            self.customerId = customerId
            self.price = price
            self.place = place
            self.date = date
            self.hour = hour
            self.departure = departure
            self.arrival = arrival
            self.car = car
        }
    }
    
    @IBOutlet weak var carBrandAndModel: UITextField!
    
    @IBOutlet weak var routeDateTime: UIDatePicker!
    
    @IBOutlet weak var routeFromStation: UITextField!
    
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
        isFromClicked = true
        self.performSegue(withIdentifier: "segueAddRouteToStationController", sender: nil)
    }
    
    @IBAction func toStatationAction(_ sender: Any) {
        isFromClicked = false
        self.performSegue(withIdentifier: "segueAddRouteToStationController", sender: nil)
    }
    
    @IBAction func addRouteAction(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeFormatter.dateFormat = "HH:mm"
        let routeDate = dateFormatter.string(from: routeDateTime.date)
        let routeTime = timeFormatter.string(from: routeDateTime.date)

        if (self.carBrandAndModel.text == ""){
            showAlert(message: "Une erreur est survenue. Veuillez renseigner le véhicule")
        } else if (self.routeFromStation.text == "") {
            showAlert(message: "Une erreur est survenue. Veuillez renseigner le lieu de départ")
        } else if (self.routeToStation.text == "") {
            showAlert(message: "Une erreur est survenue. Veuillez renseigner le lieu d'arrivé")
        } else if (self.routePlace.text == "") {
            showAlert(message: "Une erreur est survenue. Veuillez renseigner le nombre de place")
        } else if (self.routePrice.text == "") {
            showAlert(message: "Une erreur est survenue. Veuillez renseigner le prix")
        } else {
            let createRouteApi = BaseAPI<Route>(endpoint: "routes.php")
            let createdRoute = Route(OuiLiftTabBarController.connectedCustomer?.Id ?? "", self.routePrice.text!, self.routePlace.text!, routeDate, "20", OuiLiftTabBarController.routeFromStationId!, OuiLiftTabBarController.routeToStationId!, OuiLiftTabBarController.carBrandAndModelId!)
            
            createRouteApi.post(TRequest: createdRoute, completion: { (status) in
                if (status == 200) {
                    
                    OuiLiftTabBarController.initRouteField()
                    DispatchQueue.main.async {
                        self.showAlert(message: "Confirmation de votre enregistrement")
                        self.performSegue(withIdentifier: "segueToDriverRouteList", sender: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                    }
                }
            })
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Oui Lift", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: false, completion: nil)
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
        routeFromStation?.text = OuiLiftTabBarController.routeFromStationName ?? defaulValue
        routeToStation?.text = OuiLiftTabBarController.routeToStationName ?? defaulValue
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueAddRouteToStationController") {
            let searchStationsVC = segue.destination as! SearchStationTableViewController
            searchStationsVC.isFromClicked = isFromClicked
        }
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
