//
//  RouteListViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-07-27.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class RouteListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print (BrandApi.getBrands())
        print ("Mabson")
    }
    
    
}
