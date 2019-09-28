//
//  CreateAccountViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-09-25.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    
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
                customerApi.post(TRequest: customerAccout) { (status) in
                    // faire le call pour enregister la reservation
                    if (status == 200) {
                        print("insertion OK")
                    }
                }
                
            } catch(let error) {
                showAlert(message: (error as! FieldValidator.ValidationError).message)
            }
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
