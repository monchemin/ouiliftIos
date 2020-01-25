//
//  LoginViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-10-05.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
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
    
    struct RecoveryPassword: Codable {
        var eMail: String
        var language: String
        
        init (_ eMail: String) {
            self.eMail = eMail
            self.language = Locale.current.languageCode ?? "en"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        compte.delegate = self
        pwd.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    @IBAction func resetPwd(_ sender: Any) {
        let alert = UIAlertController(title: "Oui Lift", message: "Inscrivez l'adresse EMail utilisée lors de la création de votre compte. Un mot de passe temporaire vous sera envoyé à cette adresse", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        let saveAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction!) -> Void in
            let recoveryPasswordApi = BaseAPI<RecoveryPassword>(endpoint: "recovery-password.php")
            let recoveryPassword = RecoveryPassword((alert.textFields?[0].text)!)
            recoveryPasswordApi.post(TRequest: recoveryPassword, completion: { (status) in
            if (status == 200) {
                DispatchQueue.main.async {
                    self.showAlert(message: "Un mot de passe temporaire vous sera envoyé à votre adresse")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                }
            }
            });
        }
        
        saveAction.isEnabled = false
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alert.textFields?[0],
            queue: OperationQueue.main) { (notification) -> Void in
                do {
                try(alert.textFields?[0].validatedText(FieldValidator.ValidatorType.email))!
                    saveAction.isEnabled = true
                } catch( _) {
                    saveAction.isEnabled = false
                }
        }
        
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToNavigationController") {
            // passer
        }
    }*/
    

}
