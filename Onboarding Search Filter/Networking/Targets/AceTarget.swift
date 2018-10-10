//
//  AceTarget.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import Moya

internal enum AceTarget {
    case getSearchResult(filter: Filter)
}

extension AceTarget: TargetType {
    
    internal var headers: [String : String]? {
        return nil
    }
    
    /// The target's base `URL`.
    internal var baseURL: URL {
        return URL(string: "https://ace.tokopedia.com")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    internal var path: String {
        switch self {
        case .getSearchResult:
            return "/search/v2.5/product"
        }
    }
    
    /// The HTTP method used in the request.
    internal var method: Moya.Method {
        switch self {
        case .getSearchResult: return .get
        }
    }
    
    /// The parameters to be incoded in the request.
    internal var parameters: [String: Any]? {
        switch self {
        case let .getSearchResult(filter):
            return [:]
        }
    }
    
    /// The method used for parameter encoding.
    internal var parameterEncoding: ParameterEncoding {
        switch self {
        default: return URLEncoding.default
        }
    }
    
    /// Provides stub data for use in testing.
    internal var sampleData: Data { return "{ \"data\": 123 }".data(using: .utf8)! }
    
    /// The type of HTTP task to be performed.
    internal var task: Task { return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding) }
}
