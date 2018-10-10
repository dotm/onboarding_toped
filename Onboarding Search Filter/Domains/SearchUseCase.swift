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
        return Observable.of(SearchResponse(products: []))
    }
}
