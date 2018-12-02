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
    }
    
    public struct Output {
    }
    
    public func transform(input: Input) -> Output {
                
        return Output()
    }

}
