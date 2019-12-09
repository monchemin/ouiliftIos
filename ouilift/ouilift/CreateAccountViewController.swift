//
//  CreateAccountViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-09-25.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
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
        var firstName: String
        var lastName: String
        var phoneNumber: String
        var eMail: String
        var password: String
        var language: String
        
        init (_ customerFistName: String, _ customerLastName: String, _ customerPhoneNumber: String, _ customerEMailAddress: String, _ customerPassword: String) {
            self.firstName = customerFistName
            self.lastName = customerLastName
            self.phoneNumber = customerPhoneNumber
            self.eMail = customerEMailAddress
            self.password = customerPassword
            self.language = Locale.current.languageCode ?? "en"
        }
    }
    
    struct Reservation: Codable {
        var customer: String
        var route: String
        var place: String
        var language: String
        var isFirstReservation: Bool
        
        init (_ customer: String, _ route: String, _ place: String, _ isFirstReservation: Bool) {
            self.customer = customer
            self.route = route
            self.place = place
            self.isFirstReservation = isFirstReservation
            self.language = Locale.current.languageCode ?? "en"
        }
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        customerFirstName.delegate = self
        customerLastName.delegate = self
        customerPhone.delegate = self
        customerEmail.delegate = self
        customerPwd.delegate = self
        customerPwdConfirm.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
                        let reservation = Reservation(lastIndex, self.routeId!, self.place!, true)
                        reservationApi.post(TRequest: reservation, completion: { (status) in
                            if (status == 200) {
                                
                                DispatchQueue.main.async {
                                    self.showAlert(message: "Confirmation de votre enregistrement")
                                    // toDo : revenir a ecran de recherche de route
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
