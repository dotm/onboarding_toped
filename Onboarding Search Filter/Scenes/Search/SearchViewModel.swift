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
    
    public struct Input {
        public let viewDidloadTrigger: Driver<Void>
    }
    
    public struct Output {
        public let searchList: Driver<[Product]>
    }
    
    public func transform(input: Input) -> Output {
//        let getSearchList = self.fetchList
        
        //
        let response = input.viewDidloadTrigger.flatMapLatest { _ -> Driver<SearchResponse> in
            return SearchUseCase()
                .requestSearch()
                .asDriver(onErrorRecover: { error -> Driver<SearchResponse> in
                    return .empty()
                })
        }
        
        let products = response.map { response -> [Product] in
            guard let products = response.products else {
                return []
            }
            
            return products
        }
        
        
        // return data
        return Output(
            searchList: products
        )
    }
    
    private func fetchList() -> Observable<SearchResponse> {
        return SearchUseCase().requestSearch()
    }
}

