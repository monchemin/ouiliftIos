//
//  MyAccountViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-12-07.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {
    
    @IBOutlet weak var accountActivationCode: UITextField!
    
    @IBOutlet weak var activationCodePwd: UITextField!
    
    @IBOutlet weak var accountEmail: UITextField!
    
    @IBOutlet weak var emailPwd: UITextField!
    
    @IBOutlet weak var accountLastName: UITextField!
    
    @IBOutlet weak var accountFirstName: UITextField!
    
    @IBOutlet weak var accountTelephone: UITextField!
    
    @IBOutlet weak var accountOldPwd: UITextField!
    
    @IBOutlet weak var accountNewPwd: UITextField!
    
    @IBOutlet weak var newPwdConfirmation: UITextField!
    
    @IBOutlet weak var accountDriverLicensePwd: UITextField!
    
    @IBOutlet weak var accountDriverLicense: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountEmail.text = OuiLiftTabBarController.connectedCustomer?.eMail
        accountFirstName.text = OuiLiftTabBarController.connectedCustomer?.firstName
        accountLastName.text = OuiLiftTabBarController.connectedCustomer?.lastName
        accountTelephone.text = OuiLiftTabBarController.connectedCustomer?.phoneNumber
        accountDriverLicense.text = OuiLiftTabBarController.connectedCustomer?.drivingNumber
        
    }
    
    
    @IBAction func activateAccount(_ sender: Any) {
        
        struct AccountActivation: Codable {
            var Id: String
            var eMail: String
            var password: String
            var code: String
            
            init (_ Id: String, _ eMail: String, _ password: String, _ code: String) {
                self.Id = Id
                self.eMail = eMail
                self.password = password
                self.code = code
            }
        }
        
        if (accountActivationCode.text!.isEmpty) {
            showAlert(message: "Veuillez renseigner le code d'activation")
        } else if (activationCodePwd.text!.isEmpty) {
            showAlert(message: "Veuillez renseigner votre mot de passe")
        } else {
            let account = AccountActivation(OuiLiftTabBarController.connectedCustomer!.Id!, accountEmail.text!, activationCodePwd.text!, accountActivationCode.text!)
            let acountActivationApi = BaseAPI<AccountActivation>(endpoint: "activate-account.php")
            
            acountActivationApi.post(TRequest: account, completion: { (status) in
                if (status == 200) {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Votre compte a été activé")
                        self.activationCodePwd.text = ""
                        self.accountActivationCode.text = ""
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                    }
                }
            })
            
        }
    }
    
    @IBAction func modifyEmail(_ sender: Any) {
        
        struct EmailUpdate: Codable {
            var Id: String
            var password: String
            var oldMail: String
            var newMail: String
            var language: String
            
            init (_ Id: String, _ password: String, _ oldMail: String, _ newMail: String) {
                self.Id = Id
                self.password = password
                self.oldMail = oldMail
                self.newMail = newMail
                self.language = Locale.current.languageCode ?? "en"
            }
        }
        
        if (accountEmail.text!.isEmpty) {
            showAlert(message: "Veuillez renseigner votre email")
        } else {
            var validatedEmail: String
            do {
                validatedEmail = try accountEmail.validatedText(FieldValidator.ValidatorType.email)
                let emailUpdate = EmailUpdate(OuiLiftTabBarController.connectedCustomer!.Id!, emailPwd.text!, OuiLiftTabBarController.connectedCustomer!.eMail!, validatedEmail)
                let emailUpdateApi = BaseAPI<EmailUpdate>(endpoint: "change-mail.php")
                
                emailUpdateApi.post(TRequest: emailUpdate, completion: { (status) in
                    if (status == 200) {
                        DispatchQueue.main.async {
                            self.showAlert(message: "Votre email a été modifié")
                            self.emailPwd.text = ""
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                        }
                    }
                })
                
            } catch(let error) {
                showAlert(message: (error as! FieldValidator.ValidationError).message)
            }
        }
    }
    
    @IBAction func updateAccountInformation(_ sender: Any) {
        
        struct InformationUpdate: Codable {
            var Id: String
            var eMail: String
            var firstName: String
            var lastName: String
            var phoneNumber: String
            
            init (_ Id: String, _ eMail: String, _ firstName: String, _ lastName: String, _ phoneNumber: String) {
                self.Id = Id
                self.eMail = eMail
                self.firstName = firstName
                self.lastName = lastName
                self.phoneNumber = phoneNumber
            }
        }
        
        let informationUpdate = InformationUpdate(OuiLiftTabBarController.connectedCustomer!.Id!, OuiLiftTabBarController.connectedCustomer!.eMail!, accountFirstName.text!, accountLastName.text!, accountTelephone.text!)
        let informationUpdateApi = BaseAPI<InformationUpdate>(endpoint: "customer.php")
        
        informationUpdateApi.put(TRequest: informationUpdate, completion: { (status) in
            if (status == 200) {
                DispatchQueue.main.async {
                    self.showAlert(message: "Vos informations ont été mis à jour")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                }
            }
        })
        
    }
    
    @IBAction func updateAccountPwd(_ sender: Any) {
        
        struct PwdUpdate: Codable {
            var Id: String
            var eMail: String
            var newPassword: String
            var oldPassword: String
            
            init (_ Id: String, _ eMail: String, _ newPassword: String, _ oldPassword: String) {
                self.Id = Id
                self.eMail = eMail
                self.newPassword = newPassword
                self.oldPassword = oldPassword
            }
        }
        
        if (accountOldPwd.text!.isEmpty) {
            showAlert(message: "Veuillez renseigner votre ancien mot de passe")
        } else if (accountNewPwd.text!.isEmpty) {
            showAlert(message: "Veuillez renseigner votre nouveau mot de passe")
        } else if (newPwdConfirmation.text!.isEmpty) {
            showAlert(message: "Veuillez confirmer votre nouveau mot de passe")
        } else if (accountNewPwd.text != newPwdConfirmation.text) {
            showAlert(message: "Erreur confirmation de votre nouveau mot de passe")
        } else {
            let pwdUpdate = PwdUpdate(OuiLiftTabBarController.connectedCustomer!.Id!, OuiLiftTabBarController.connectedCustomer!.eMail!, accountNewPwd.text!, accountOldPwd.text!)
            let pwdUpdateApi = BaseAPI<PwdUpdate>(endpoint: "change-password.php")
            
            pwdUpdateApi.post(TRequest: pwdUpdate, completion: { (status) in
                if (status == 200) {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Votre mot de passe a été modifié")
                        self.accountOldPwd.text = ""
                        self.accountNewPwd.text = ""
                        self.newPwdConfirmation.text = ""
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                    }
                }
            })
        }
        
    }
    
    @IBAction func becomeDriver(_ sender: Any) {
        
        struct Driver: Codable {
            var Id: String
            var drivingNumber: String
            var eMail: String
            var password: String
            
            init (_ Id: String, _ drivingNumber: String, _ eMail: String, _ password: String) {
                self.Id = Id
                self.drivingNumber = drivingNumber
                self.eMail = eMail
                self.password = password
            }
        }
        
        if (accountDriverLicensePwd.text!.isEmpty) {
            showAlert(message: "Veuillez renseigner votre mot de passe")
        } else if (accountDriverLicense.text!.isEmpty) {
            showAlert(message: "Veuillez renseigner votre numéro de permis de conduire")
        } else {
            let driver = Driver(OuiLiftTabBarController.connectedCustomer!.Id!, accountDriverLicense.text!, OuiLiftTabBarController.connectedCustomer!.eMail!, accountDriverLicensePwd.text!)
            let driverApi = BaseAPI<Driver>(endpoint: "driver.php")
            
            driverApi.post(TRequest: driver, completion: { (status) in
                if (status == 200) {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Vos informations ont été enregistrées")
                        self.accountDriverLicensePwd.text = ""
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Une erreur est survenue. Veuillez réessayer")
                    }
                }
            })
        }
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        OuiLiftTabBarController.connectedCustomer = nil
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
