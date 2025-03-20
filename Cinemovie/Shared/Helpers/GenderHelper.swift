//
//  GenderHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import Foundation

struct GenderHelper {
    static func identifyGender(gender: Int) -> String {
        switch gender {
        case 1: return "Female"
        case 2: return "Male"
        case 3: return "Non-Binary"
        default: return "Not Specified"
        }
    }
}
