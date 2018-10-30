//
//  SearchViewModel.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

@objc public final class SearchViewModel: NSObject, ViewModelType {
    
    private let filter: Filter
    private let useCase: SearchUseCase

    init(filter: Filter, useCase: SearchUseCase) {
        self.filter = filter
        self.useCase = useCase
    }

    public struct Input {
        let viewDidLoadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let filterButtonTapTrigger: Driver<Void>
        let newFilterTrigger: Driver<Filter>
    }
    
    public struct Output {
        let searchList: Driver<[Product]>
        let openFilter: Driver<Filter>
    }
    
    public func transform(input: Input) -> Output {
        let filter = BehaviorRelay(value: self.filter)
        let currentProducts = BehaviorRelay(value: [Product]())

        let newFilterTrigger = input.newFilterTrigger
            .map { _ in}
            .do(onNext: { _ in
                currentProducts.accept([Product]())
            })

        let filterDriver = Driver.merge(filter.asDriver(), input.newFilterTrigger)
        let refreshDataTrigger = Driver.merge(input.loadMoreTrigger, input.viewDidLoadTrigger, newFilterTrigger)

        let response = refreshDataTrigger
            .withLatestFrom(filterDriver)
            .flatMapLatest { (filter) -> Driver<SearchResponse> in
                return self.useCase
                    .requestSearch(filter: filter)
                    .asDriver(onErrorRecover: { (error) -> Driver<SearchResponse> in
                        return .empty()
                    })
        }
        
        let products = response.map { (response) -> [Product] in
            let products = response.products
            if products.count > 0 {
                var currentFilter = filter.value
                currentFilter.start = currentFilter.start + 10
                filter.accept(currentFilter)
                
                let newProducts = currentProducts.value + products
                currentProducts.accept(newProducts)
            }
            return currentProducts.value
        }
        
        let openFilter = input.filterButtonTapTrigger
            .withLatestFrom(filterDriver) { (_, filter) -> Filter in
//                var newFilter = filter
//                newFilter.wholesale = true
//                return newFilter
                return filter
                
        }
        
        return Output(searchList: products, openFilter: openFilter)
    }

}

