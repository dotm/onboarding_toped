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
    
    public init(filter: Filter) {
        self.filter = filter
    }
    
    public struct Input {
        let wholeSaleTrigger: Driver<Bool>
    }
    
    public struct Output {
        let wholeSaleChanged: Driver<Bool>
        let filterOutput: Driver<Filter>
    }
    
    public func transform(input: Input) -> Output {
        
        let currentFilter = BehaviorRelay(value: self.filter)
        
        let wholesale = input.wholeSaleTrigger.map { (wholesale) -> Bool in
            return wholesale
        }
        
        let enableReset = currentFilter.map { [filter] currenFilter -> Bool in
            return
        }
        
        let filterDriver = Driver.merge(
            wholesale
                .withLatestFrom(currentFilter.asDriver(), resultSelector: { isWholeSale, filter -> Filter in
                    var newFilter = filter
                    newFilter.wholesale = isWholeSale
                    
                    currentFilter.accept(newFilter)
                }))
 
        //let apply = input.applyTrigger.wi
        
        return Output(
            wholeSaleChanged: wholesale,
            filterOutput: filterDriver
        )
    }
}
