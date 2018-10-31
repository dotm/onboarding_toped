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
//        let startPage = BehaviorRelay(value: 0)
        var startPage = 0

        let newFilterTrigger = input.newFilterTrigger
            .map { _ in}
            .do(onNext: { _ in
                currentProducts.accept([Product]())
                startPage = 0
            })

        let filterDriver = Driver.merge(filter.asDriver(), input.newFilterTrigger)
        let refreshDataTrigger = Driver.merge(input.loadMoreTrigger, input.viewDidLoadTrigger, newFilterTrigger)

        let response = refreshDataTrigger
            .withLatestFrom(filterDriver)
            .flatMapLatest { (filter) -> Driver<SearchResponse> in
                return self.useCase
                    .requestSearch(filter: filter, start: startPage)
                    .asDriver(onErrorRecover: { (error) -> Driver<SearchResponse> in
                        return .empty()
                    })
        }
        
//        let combinedResponse = Driver.combineLatest(response, filterDriver)
        
        let products = response.map { (response) -> [Product] in
            let products = response.products
            if products.count > 0 {
//                filter.accept(f)
                let newProducts = currentProducts.value + products
                startPage = startPage + 10
                currentProducts.accept(newProducts)
            }
            return currentProducts.value
        }
        
        let openFilter = input.filterButtonTapTrigger
            .withLatestFrom(filterDriver) { (_, f) -> Filter in
                return f
                
        }
        
        return Output(searchList: products, openFilter: openFilter)
    }

}
