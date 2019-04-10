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
        let setupFilter: Driver<Filter>
        let minimumPriceTextFieldChanged: Driver<Float>
        let maximumPriceTextFieldChanged: Driver<Float>
        let priceSliderChanged: Driver<(Float, Float)>
        let wholeSaleFilterChanged: Driver<Bool>
        let goldMerchantTagTrigger: Driver<Bool>
        let officialStoreTagTrigger: Driver<Bool>
    }
    
    public struct Output {
        let setupFilter: Driver<Filter>
        let minimumPriceText: Driver<String>
        let maximumPriceText: Driver<String>
        let selectedMinimum: Driver<Float>
        let selectedMaximum: Driver<Float>
        let wholesaleSwitch: Driver<Bool>
        let goldMerchantSelected: Driver<Bool>
        let officialStoreSelected: Driver<Bool>
        let filter: Driver<Filter>
    }
    
    public func transform(input: Input) -> Output {
        //#error("intercept minimumPriceTextFieldChanged, validate min < max, fix 0032 string to number")
        let initialLowerPrice = Float(initialFilter.pmin)
        let initialHigherPrice = Float(initialFilter.pmax)
        
        let minimumPriceTextFieldChangedDriver = input.minimumPriceTextFieldChanged.startWith(initialLowerPrice)
        let maximumPriceTextFieldChangedDriver = input.maximumPriceTextFieldChanged.startWith(initialHigherPrice)
        let priceLabelChangedDriver: Driver<(Float, Float)> =
            Driver.combineLatest(
                minimumPriceTextFieldChangedDriver,
                maximumPriceTextFieldChangedDriver
            )
        let priceSliderChangedDriver: Driver<(Float, Float)> = input.priceSliderChanged.startWith((initialLowerPrice, initialHigherPrice))
        let priceChangedDriver: Driver<(Float, Float)> = Driver.merge(
            priceLabelChangedDriver,
            priceSliderChangedDriver
        )
        let filterDriver = Driver.combineLatest(
            priceChangedDriver,
            input.wholeSaleFilterChanged.startWith(initialFilter.wholesale),
            input.goldMerchantTagTrigger.startWith(initialFilter.fshop == Filter.GOLD_MERCHANT_FSHOP_TAG),
            input.officialStoreTagTrigger.startWith(initialFilter.official)
        ).map { arg -> Filter in
            let ((lowerPrice, higherPrice), wholesale, goldMerchantTag, officialStoreTag) = arg
            return Filter(
                pmin: Int(lowerPrice),
                pmax: Int(higherPrice),
                wholesale: wholesale,
                official: officialStoreTag,
                fshop: goldMerchantTag ? Filter.GOLD_MERCHANT_FSHOP_TAG : Filter.DEFAULT_FSHOP_TAG
            )
        }
        
        let sliderLowerPriceChanged = priceSliderChangedDriver.map { (min, _) -> Float in return min }
        let minimumPriceText = Driver.merge(
            minimumPriceTextFieldChangedDriver,
            sliderLowerPriceChanged
        ).map { (min) -> String in
            return String(Int(min))
        }
        let sliderHigherPriceChanged = priceSliderChangedDriver.map { (_, max) -> Float in return max }
        let maximumPriceText = Driver.merge(
            maximumPriceTextFieldChangedDriver,
            sliderHigherPriceChanged
        ).map { (max) -> String in
            return String(Int(max))
        }
        let selectedMinimum = priceLabelChangedDriver.map { (min, _) -> Float in
            return min
        }
        let selectedMaximum = priceLabelChangedDriver.map { (_, max) -> Float in
            return max
        }
        
        return Output(
            setupFilter: input.setupFilter,
            minimumPriceText: minimumPriceText,
            maximumPriceText: maximumPriceText,
            selectedMinimum: selectedMinimum,
            selectedMaximum: selectedMaximum,
            wholesaleSwitch: input.wholeSaleFilterChanged,
            goldMerchantSelected: input.goldMerchantTagTrigger,
            officialStoreSelected: input.officialStoreTagTrigger,
            filter: filterDriver
        )
    }
}
