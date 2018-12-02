//
//  ShopFilterViewModel.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

@objc public final class ShopFilterViewModel: NSObject, ViewModelType {
    
    private let filter: Filter
    
    public init(filter: Filter) {
        self.filter = filter
    }
    
    public struct Input {
    }
    
    public struct Output {
    }
    
    public func transform(input: Input) -> Output {
        return Output()
    }
}
