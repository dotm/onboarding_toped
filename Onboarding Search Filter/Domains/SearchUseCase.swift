//
//  SearchUseCase.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import Foundation
import Moya
import RxSwift

public class SearchUseCase {
    public func requestSearch() -> Observable<SearchResponse> {
        let provider = MoyaProvider<AceTarget>()
        let response = provider.rx.request(.getSearchResult()).map(SearchResponse.self)
//        return Observable.of(SearchResponse(products: []))
        return response.asObservable()
    }
}
