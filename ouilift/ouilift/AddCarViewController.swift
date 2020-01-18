//
//  AddCarViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-12-30.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class AddCarViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var carNumber: UITextField!
    
    @IBOutlet weak var carModel: UIPickerView!
    
    @IBOutlet weak var carColor: UIPickerView!
    
    @IBOutlet weak var carYear: UITextField!
    
    struct CreatedCar: Codable {
        var customerId: String
        var year: String
        var model: String
        var color: String
        var number: String
        
        init (_ customerId: String, _ year: String, _ model: String, _ color: String, _ number: String) {
            self.customerId = customerId
            self.year = year
            self.model = model
            self.color = color
            self.number = number
        }
    }
    
    struct CarBrandModel: Codable {
        var Id: String
        var model: String
        
        init (_ Id: String, _ model: String) {
            self.Id = Id
            self.model = model
        }
    }
    
    struct CarColor: Codable {
        var Id: String
        var colorName: String
        
        init (_ Id: String, _ colorName: String) {
            self.Id = Id
            self.colorName = colorName
        }
    }
    
    var carBrandModels : [CarBrandModel] = []
    
    var carColors : [CarColor] = []
    
    var selectedModel: String!
    
    var selectedColor: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        carNumber.delegate = self
        carModel.delegate = self
        carColor.delegate = self
        carYear.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
       let carBrandModelApi = BaseAPI<CarBrandModel>(endpoint: "car-brand-model.php")
        carBrandModelApi.get(completion: {(result) in
            self.carBrandModels = result;
            /*DispatchQueue.main.async { toDo
                // self.viewDidLoad()
                // self.viewWillAppear(true)
            }*/
        })
        
        let carColorApi = BaseAPI<CarColor>(endpoint: "car-colors.php")
        carColorApi.get(completion: {(result) in
            self.carColors = result;
            DispatchQueue.main.async {
                self.viewDidLoad()
                self.viewWillAppear(true)
            }
        })
    }
    
    
    @IBAction func addCar(_ sender: Any) {
        
        if (self.carYear.text == ""){
            showAlert(message: "Une erreur est survenue. Veuillez renseigner l'année du véhicule")
        }
        else if (self.carNumber.text == "") {
            showAlert(message: "Une erreur est survenue. Veuillez renseigner le numéro du véhicule")
        } else {
            /**/
            var validatedCarYear: String
            do {
                validatedCarYear = try carYear.validatedText(FieldValidator.ValidatorType.year)
                let createCarApi = BaseAPI<CreatedCar>(endpoint: "car-create.php")
                let createdCar = CreatedCar(OuiLiftTabBarController.connectedCustomer?.Id ?? "", validatedCarYear, self.selectedModel, self.selectedColor, self.carNumber.text!)
                
                createCarApi.post(TRequest: createdCar, completion: { (status) in
                    if (status == 200) {
                        
                        DispatchQueue.main.async {
                            self.showAlert(message: "Confirmation de votre enregistrement")
                            self.performSegue(withIdentifier: "segueToCarTableViewController", sender: nil)
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
        /**/}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToCarTableViewController") {
            let totoVC = segue.destination as! CustomerCarsTableViewController
            totoVC.viewDidLoad()
        }
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return carBrandModels.count
        } else {
            return carColors.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return carBrandModels[row].model
        } else {
            return carColors[row].colorName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            self.selectedModel = carBrandModels[row].Id
        } else {
            self.selectedColor = carColors[row].Id
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
