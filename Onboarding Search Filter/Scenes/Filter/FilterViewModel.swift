//
//  FilterViewModel.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

@objc public final class FilterViewModel: NSObject, ViewModelType {

    private let filter: Filter
    
    init(filter: Filter) {
        self.filter = filter
    }
    public struct Input {
        let applyButtonTapTrigger: Driver<Filter>
    }
    
    public struct Output {
//        let filter: Driver<Filter>
    }
    
    public func transform(input: Input) -> Output {
        
        let filter = BehaviorRelay(value: self.filter)
        
        let filterDriver = Driver.merge(filter.asDriver(), input.applyButtonTapTrigger)
        
        
        
        return Output()
    }
}
