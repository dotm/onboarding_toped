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
        let goldButtonTrigger: Driver<Void>
        let officialButtonTrigger: Driver<Void>
        let applyTrigger: Driver<Void>
        let resetTrigger: Driver<Void>
    }
    
    public struct Output {
        let isShowReset: Driver<Bool>
        let isGoldChecked: Driver<Bool>
        let isOfficialChecked: Driver<Bool>
        let applyTapped: Driver<Filter>
    }
    
    public func transform(input: Input) -> Output {
        
        let currentFilter = BehaviorRelay(value: self.filter)
        
        let goldChecked = Driver.merge(
            input.resetTrigger
                .map { _ -> Bool in
                    return false
            }, input.goldButtonTrigger
                .withLatestFrom(currentFilter.asDriver()) { (_, filter) -> Bool in
                    return filter.fshop == 0 ? true : false
        })
            .do(onNext: { goldChecked in
                var newFilter = currentFilter.value
                newFilter.fshop = goldChecked ? 1 : 0
                currentFilter.accept(newFilter)
            }).startWith(currentFilter.value.fshop != 0)
        
        //        let officialChecked = input.officialButtonTrigger.withLatestFrom(currentFilter.asDriver()) { (_, filter) -> Bool in
        //            var newFilter = filter
        //            newFilter.official = !newFilter.official
        //            currentFilter.accept(newFilter)
        //            return currentFilter.value.official
        //        }
        
        let officialChecked = Driver.merge(
            input.resetTrigger.map({ _ -> Bool in
                return false
            }), input.officialButtonTrigger.withLatestFrom(currentFilter.asDriver(), resultSelector: { (_, filter) -> Bool in
                return !filter.official
            })
            ).do(onNext: { (officialChecked) in
                var newFilter = currentFilter.value
                newFilter.official = officialChecked
                currentFilter.accept(newFilter)
            }).startWith(currentFilter.value.official)
        
        let showReset = currentFilter.asDriver()
            .map { (filter) -> Bool in
                return filter.fshop == 0 && !filter.official
        }
        
        let apply = input.applyTrigger
            .withLatestFrom(currentFilter.asDriver()) { (_, filter) -> Filter in
                return filter
        }
        
        
        return Output(
            isShowReset: showReset,
            isGoldChecked: goldChecked,
            isOfficialChecked: officialChecked,
            applyTapped: apply
        )
    }
}
