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

public final class SearchViewModel: NSObject, ViewModelType {
    
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
        let currentProducts = BehaviorRelay(value: [Product]())
        var startPage = 0
        
        let newFilterTrigger = input.newFilterTrigger
            .map { _ in }
            .do(onNext: { _ in
                currentProducts.accept([Product]())
                startPage = 0
            })
        
        let filterDriver = input.newFilterTrigger.startWith(self.filter)
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
        
        let products = response.map { (response) -> [Product] in
            let products = response.products
            if products.count > 0 {
                let newProducts = currentProducts.value + products
                startPage += 10
                currentProducts.accept(newProducts)
            }
            
            return currentProducts.value
        }
        
        let openFilter = input.filterButtonTapTrigger
            .withLatestFrom(filterDriver) { (_, filter) -> Filter in
                return filter
        }
        
        return Output(searchList: products, openFilter: openFilter)
    }

}
