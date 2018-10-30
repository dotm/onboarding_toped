//
//  SearchUseCase.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import Foundation
import Moya
import RxSwift

protocol SearchUseCase {
    func requestSearch(filter: Filter) -> Observable<SearchResponse>
}

class DefaultSearchUseCase:  SearchUseCase {
    let provider = MoyaProvider<AceTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func requestSearch(filter: Filter) -> Observable<SearchResponse> {
        return provider.rx.request(.fetchSearchResult(filter: filter))
            .map(SearchResponse.self)
            .asObservable()
            .debug()
    }
}

