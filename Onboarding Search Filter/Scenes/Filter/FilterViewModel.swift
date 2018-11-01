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
        let viewDidLoadTrigger: Driver<Void>
        let wholeSaleTrigger: Driver<Bool>
        let resetTrigger: Driver<Void>
        let applyTrigger: Driver<Void>
        let shopTypeTrigger: Driver<Void>
        let goldMerchantTrigger: Driver<Void>
        let officialStoreTrigger: Driver<Void>
        let newFilterTrigger: Driver<Filter>
    }
    
    public struct Output {
        let wholeSaleChanged: Driver<Bool>
        let toggleReset: Driver<Bool>
        let applyTapped: Driver<Filter>
        let shopTypeTapped: Driver<Filter>
        let showGoldMerchant: Driver<Bool>
        let showOfficialStore: Driver<Bool>
    }
    
    public func transform(input: Input) -> Output {
        
        let currentFilter = BehaviorRelay(value: self.filter)
        
        let filterDriver = Driver.merge(
            currentFilter.asDriver(),
            input.wholeSaleTrigger
                .withLatestFrom(currentFilter.asDriver(), resultSelector: { isWholeSale, filter -> Filter in
                    var newFilter = filter
                    newFilter.wholesale = isWholeSale
                    currentFilter.accept(newFilter)
                    return currentFilter.value
                }),
            input.resetTrigger
                .map({ _ -> Filter in
                    let filter = Filter()
                    currentFilter.accept(filter)
                    return currentFilter.value
                }),
            input.goldMerchantTrigger
                .withLatestFrom(currentFilter.asDriver(), resultSelector: { (_, filter) -> Filter in
                    var newFilter = filter
                    newFilter.fshop = 0
                    currentFilter.accept(newFilter)
                    return currentFilter.value
                }),
            input.officialStoreTrigger
                .withLatestFrom(currentFilter.asDriver(), resultSelector: { (_, filter) -> Filter in
                    var newFilter = filter
                    newFilter.official = false
                    currentFilter.accept(newFilter)
                    return currentFilter.value
                }),
            input.newFilterTrigger.withLatestFrom(currentFilter.asDriver(), resultSelector: { (filter, _) -> Filter in
                currentFilter.accept(filter)
                return currentFilter.value
            })
            )
        
        let wholesale = filterDriver.map { filter -> Bool in
            return filter.wholesale
        }
        
        let enableReset = filterDriver.map { currenFilter -> Bool in
            return currentFilter.value.wholesale != true
            }.asDriver(onErrorRecover: {_ in
                return .empty()
            })
 
        let apply = input.applyTrigger.map { _ -> Filter in
            return currentFilter.value
        }
        
        let shopType = input.shopTypeTrigger
            .withLatestFrom(filterDriver)
            .map { (filter) -> Filter in
                return filter
        }
        
        let goldMerchant = filterDriver.map { (filter) -> Bool in
            return filter.fshop == 0
        }
        
        let officialStore = filterDriver.map { (filter) -> Bool in
            return !filter.official
        }
        
        let _ = input.newFilterTrigger.map { (filter) -> Filter in
            debugPrint(filter)
            return filter
        }
        
        return Output(
            wholeSaleChanged: wholesale,
            toggleReset: enableReset,
            applyTapped: apply,
            shopTypeTapped: shopType,
            showGoldMerchant: goldMerchant,
            showOfficialStore: officialStore
        )
    }
}
