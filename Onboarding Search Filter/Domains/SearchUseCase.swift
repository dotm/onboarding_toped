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
    func requestSearch(filter: Filter, start: Int) -> Observable<SearchResponse>
}

class DefaultSearchUseCase:  SearchUseCase {
    let provider = MoyaProvider<AceTarget>()
    
    func requestSearch(filter: Filter, start: Int) -> Observable<SearchResponse> {
        return provider.rx.request(.fetchSearchResult(filter: filter, start: start))
            .map(SearchResponse.self)
            .asObservable()
    }
}

