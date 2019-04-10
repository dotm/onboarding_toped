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
    
    private let initialFilter: Filter
    
    public init(filter: Filter) {
        self.initialFilter = filter
    }
    
    public struct Input {
        let setupFilter: Driver<Filter>
        let goldMerchantTagTrigger: Driver<Bool>
        let officialStoreTagTrigger: Driver<Bool>
    }
    
    public struct Output {
        let setupFilter: Driver<Filter>
        let goldMerchantSelected: Driver<Bool>
        let officialStoreSelected: Driver<Bool>
        let filter: Driver<Filter>
    }
    
    public func transform(input: Input) -> Output {
        let filterDriver = Driver.combineLatest(
            input.goldMerchantTagTrigger.startWith(initialFilter.fshop == Filter.GOLD_MERCHANT_FSHOP_TAG),
            input.officialStoreTagTrigger.startWith(initialFilter.official)
        ).map { [weak self] arg -> Filter in
            guard let self = self else {return Filter()}
            let (goldMerchantTag, officialStoreTag) = arg
            return Filter(
                pmin: self.initialFilter.pmin,
                pmax: self.initialFilter.pmax,
                wholesale: self.initialFilter.wholesale,
                official: officialStoreTag,
                fshop: goldMerchantTag ? Filter.GOLD_MERCHANT_FSHOP_TAG : Filter.DEFAULT_FSHOP_TAG
            )
        }
        return Output(
            setupFilter: input.setupFilter,
            goldMerchantSelected: input.goldMerchantTagTrigger,
            officialStoreSelected: input.officialStoreTagTrigger,
            filter: filterDriver
        )
    }
}
