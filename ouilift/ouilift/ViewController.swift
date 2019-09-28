//
//  ViewController.swift
//  ouilift
//
//  Created by Mewena on 2019-07-13.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
}

extension UITextField {
    func validatedText (_ fieldType: FieldValidator.ValidatorType) throws -> String {
        let fieldValidator = FieldValidator()
        return try fieldValidator.isValid(fieldType, self.text ?? "")
    }
}
