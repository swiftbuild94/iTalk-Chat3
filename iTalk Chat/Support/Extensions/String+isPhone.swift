//
//  String+isPhone.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import Foundation
import UIKit

let __phoneRegex = "[0-9]([0-9+-]{0,30}[0-9])?"
let __phonePredicate = NSPredicate(format: "SELF MATCHES %@", __phoneRegex)

extension String {
    func isPhone() -> Bool {
        return __phonePredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isPhone() -> Bool {
        return self.text?.isPhone() ?? false
    }
}
