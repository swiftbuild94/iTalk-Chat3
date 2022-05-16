//
//  String+Extension.swift
//  iTalk
//
//  Created by Patricio Benavente on 27/09/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//
// Usage:
// if !email.isEmail {
//      self.errorMessage = "Please enter a valid email"
//      return
//  }

import Foundation
import UIKit

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return self.text?.isEmail() ?? false
    }
}

//var supIsValidEmailAddress: Bool {
//        return self.contains(".")
//            && self.contains("@")
//            && self.count >= 6 // "a@b.cd".count
//            && self.first != .some("@")
//            && self.last != .some("@")
//            && self.last != .some(".")
//            && self.dropLast(1).last != .some(".")
//    }
//
//    var supValidateAsEmailAddress: Validation {
//        return isEmpty ? .valid : supIsValidEmailAddress ? .valid : .invalid(error: Locales.commonTextInputEmailErrorInvalid)
//    }

//var supIsValidPhoneNumber: Bool {
//      return lowercased().allSatisfy { !"abcdefghijklmnopqrstuvwxzy".contains($0) }
//  }
//
//  var supValidateAsPhoneNumber: Validation {
//      return isEmpty ? .none : supIsValidPhoneNumber ? .valid : .invalid(error: Locales.commonTextInputPhoneErrorInvalid )
//  }
//
//  var supIsValidSmsVerificationCode: Bool {
//      return count == 4
//          && allSatisfy { "0123456789".contains($0) }
//  }
//
//  var supValidateAsSmsVerificationCode: Validation {
//      return isEmpty ? .none : supIsValidSmsVerificationCode ? .valid : .invalid(error: Locales.enterPhoneVerificationTextInputCodeErrorEnterFourNumbers)
//  }


