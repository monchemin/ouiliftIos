//
//  LoginViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-10-05.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var compte: UITextField!
    
    @IBOutlet weak var pwd: UITextField!
    
    @IBOutlet weak var userId: UILabel!
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    struct CustomerAccess: Codable {
        var login: String
        var password: String
        
        init (_ login: String, _ password: String) {
            self.login = login
            self.password = password
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func connect(_ sender: Any) {
        if (compte.text!.isEmpty) {
            showAlert(message: "Veuillez renseigner votre email")
            //self.pwd.becomeFirstResponder()
        } else if (pwd.text!.isEmpty) {
            showAlert(message: "Veuillez renseigner votre mot de passe")
            //compte.accessibilityElementDidBecomeFocused()
        } else {
            var validatedEmail: String
            do {
                validatedEmail = try compte.validatedText(FieldValidator.ValidatorType.email)
                let customerAccess = CustomerAccess(validatedEmail, pwd.text!)
                let loginApi = BaseAPI<CustomerAccess>(endpoint: "login.php")
                loginApi.postIsLog(TRequest: customerAccess, completion: { (isLog, customer) in
                    if (isLog) {
                        OuiLiftTabBarController.connectedCustomer = customer
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "segueToNavigationController", sender: nil)
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: "Erreur compte ou mot de passe")
                        }
                    }
                })
                
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToNavigationController") {
            // passer
        }
    }*/
    

}
