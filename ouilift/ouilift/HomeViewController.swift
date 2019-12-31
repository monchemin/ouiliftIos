//
//  HomeViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-12-14.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {// HomeViewController
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

        // Do any additional setup after loading the view.
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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
