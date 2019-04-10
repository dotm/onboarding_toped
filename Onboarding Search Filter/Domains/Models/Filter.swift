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
        self.init(pmin: 0, pmax: 0, wholesale: false, official: false)
    }
    init(pmin: Int, pmax: Int, wholesale: Bool, official: Bool) {
        self.q = "Samsung"
        self.pmin = pmin
        self.pmax = pmax
        self.wholesale = wholesale
        self.official = official
        fshop = 0
        rows = 10
    }
}
