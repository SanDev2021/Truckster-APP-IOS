//
//  Extensions.swift
//  demo
//
//   Created by RAKESH KUMAR, Sandeep kaur on 2021-02-11.
//

import Foundation
extension String{
    enum ValidityType {
        case postalCode
    }
    enum Regex:String {
        case postalCode  = "[A-Z]{1,1}[0-9]{1,1}[A-Z]{1,1}[0-9]{1,1}[A-Z]{1,1}[0-9]{1,1}"
    }
    func isValid(_ validityType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        switch validityType {
        case .postalCode:
           regex = Regex.postalCode .rawValue
        }
        return NSPredicate(format: format,regex).evaluate(with: self)
    }
    }
