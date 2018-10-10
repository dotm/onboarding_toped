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
    }
    
    public struct Output {
    }
    
    public func transform(input: Input) -> Output {
        return Output()
    }
}

