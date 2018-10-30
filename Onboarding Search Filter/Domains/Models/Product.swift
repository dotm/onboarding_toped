//
//  Product.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import Foundation

public struct Product: Decodable {
    internal let id: Int?
    internal let name: String?
    internal let price: String?
    internal let imageURLString: String?
    
    internal enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case imageURLString = "image_uri"
    }
}
