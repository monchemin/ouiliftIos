//
//  CreateAccountViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-09-25.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    var routeId: String?
    var place: String?
    var price: String?
    
    @IBOutlet weak var customerFirstName: UITextField!
    
    @IBOutlet weak var customerLastName: UITextField!
    
    @IBOutlet weak var customerPhone: UITextField!
    
    @IBOutlet weak var customerEmail: UITextField!
    
    @IBOutlet weak var customerPwd: UITextField!
    
    @IBOutlet weak var customerPwdConfirm: UITextField!
    
    struct Customer: Codable {
        var customerFistName: String
        var customerLastName: String
        var customerPhoneNumber: String
        var customerEMailAddress: String
        var customerPassword: String
        
        init (_ customerFistName: String, _ customerLastName: String, _ customerPhoneNumber: String, _ customerEMailAddress: String, _ customerPassword: String) {
            self.customerFistName = customerFistName
            self.customerLastName = customerLastName
            self.customerPhoneNumber = customerPhoneNumber
            self.customerEMailAddress = customerEMailAddress
            self.customerPassword = customerPassword
        }
    }
    
    struct Reservation: Codable {
        // var reservationDate: String
        var FK_Route: String
        var FK_Customer: String
        var place: String
        
        init (_ FK_Route: String, _ FK_Customer: String, _ place: String) {
            self.FK_Route = FK_Route
            self.FK_Customer = FK_Customer
            self.place = place
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func createCustomer(_ sender: Any) {
        
        if (customerPwd.text == customerPwdConfirm.text) {
            var validatedEmail: String
            do {
                validatedEmail = try customerEmail.validatedText(FieldValidator.ValidatorType.email)
                
                let customerAccout = Customer(customerFirstName.text ?? "", customerLastName.text ?? "", customerPhone.text ?? "", validatedEmail, customerPwd.text ?? "")
                let customerApi = BaseAPI<Customer>(endpoint: "customer.php")
                customerApi.postLastIndex(TRequest: customerAccout, completion: { (lastIndex) in
                    if (lastIndex != "") {
                        // faire le call pour enregister la reservation
                        let reservationApi = BaseAPI<Reservation>(endpoint: "reservations.php")
                        let reservation = Reservation(self.routeId!, lastIndex, self.place!)
                        reservationApi.post(TRequest: reservation, completion: { (status) in
                            if (status == 200) {
                                // toDo modifier la methode showAlert pour lui passer une fonction callback qui fera l'action suivante
                                DispatchQueue.main.async {
                                    self.showAlert(message: "Confirmation de votre enregistrement")
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                                }
                            }
                        })
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                        }
                    }
                    
                })
                
            } catch(let error) {
                showAlert(message: (error as! FieldValidator.ValidationError).message)
            }
        } else {
            showAlert(message: "Erreur confirmation mot de passe")
            // customerPwdConfirm.becomeFirstResponder() // toDo focus dans les fields erreur
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Oui Lift", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: false, completion: nil)
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
