//
//  Filter.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import Foundation

public struct Filter {
    var q: String
    var pmin: Int
    var pmax: Int
    var wholesale: Bool
    var official: Bool
    var fshop: Int
    var rows: Int
    
    init() {
        self.init(pmin: 0, pmax: 0, wholesale: false, official: false, fshop: 0)
    }
    init(pmin: Int, pmax: Int, wholesale: Bool, official: Bool, fshop: Int) {
        self.q = "Samsung"
        self.pmin = pmin
        self.pmax = pmax
        self.wholesale = wholesale
        self.official = official
        self.fshop = fshop
        rows = 10
    }
    
    static let GOLD_MERCHANT_FSHOP_TAG = 2
    static let DEFAULT_FSHOP_TAG = 0
}
