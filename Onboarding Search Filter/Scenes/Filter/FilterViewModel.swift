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
    
    private let initialFilter: Filter
    
    public init(filter: Filter) {
        self.initialFilter = filter
    }
    
    public struct Input {
        let viewDidLoadTrigger: Driver<Void>
        let priceSliderChanged: Driver<(lowerValue: Float, higherValue: Float)>
        let wholeSaleFilterChanged: Driver<Bool>
    }
    
    public struct Output {
        let minimumPriceText: Driver<String>
        let maximumPriceText: Driver<String>
        let wholesaleSwitch: Driver<Bool>
        let filter: Driver<Filter>
    }
    
    public func transform(input: Input) -> Output {
        let filterDriver = Driver.combineLatest(
            input.priceSliderChanged.startWith((lowerValue: Float(initialFilter.pmin), higherValue: Float(initialFilter.pmax))),
            input.wholeSaleFilterChanged.startWith(initialFilter.wholesale)
        ).map { (priceRange, wholesale) -> Filter in
            return Filter(
                pmin: Int(priceRange.lowerValue),
                pmax: Int(priceRange.higherValue),
                wholesale: wholesale
            )
        }
        
        let minimumPriceText = filterDriver.map { (filter) -> String in
            return String(filter.pmin)
        }
        let maximumPriceText = filterDriver.map { (filter) -> String in
            return String(filter.pmax)
        }
        let wholesaleSwitch = filterDriver.map { (filter) -> Bool in
            return filter.wholesale
        }
        
        return Output(
            minimumPriceText: minimumPriceText,
            maximumPriceText: maximumPriceText,
            wholesaleSwitch: wholesaleSwitch,
            filter: filterDriver
        )
    }
}
