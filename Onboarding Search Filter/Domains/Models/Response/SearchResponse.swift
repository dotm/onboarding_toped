//
//  SearchResponse.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import Foundation

public struct SearchResponse {
    public let products: [Product]
    
    public enum CodingKeys: String, CodingKey {
        case products = "data"
    }
}

extension SearchResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        products = try container.decodeIfPresent([Product].self, forKey: .products) ?? []
    }
}
