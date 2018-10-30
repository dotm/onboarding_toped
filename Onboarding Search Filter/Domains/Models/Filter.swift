//
//  Filter.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import Foundation

public struct Filter {
    var q: String = "Samsung"
    var pmin: Int = 0
    var pmax: Int = 0
    var wholesale: Bool = false
    var official: Bool = false
    var fshop: Int = 0
    var start: Int = 0
    var rows: Int = 10
}
