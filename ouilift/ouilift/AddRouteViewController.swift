//
//  AddRouteViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-12-15.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class AddRouteViewController: UIViewController {
    
    var defaulValue: String = ""
    
    var isFromClicked: Bool?
    
    @IBOutlet weak var carBrandAndModel: UITextField!
    
    @IBAction func carAction(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToCustomerCarViewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

        carBrandAndModel?.text = OuiLiftTabBarController.carBrandAndModel ?? defaulValue
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
