//
//  FilterViewModel.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

@objc public final class FilterViewModel: NSObject, ViewModelType {
    
    private let filter: Filter
    
    public init(filter: Filter) {
        self.filter = filter
    }
    
    public struct Input {
    }
    
    public struct Output {
        let selectedMinimum: Driver<Float>
        let selectedMaximum: Driver<Float>
    }
    
    public func transform(input: Input) -> Output {
        let filter = Driver.just(self.filter)
        
        let selectedMinimum = filter.map { (filter) -> Float in
            return Float(filter.pmin)
        }
        let selectedMaximum = filter.map { (filter) -> Float in
            return Float(filter.pmax)
        }
        
        return Output(selectedMinimum: selectedMinimum, selectedMaximum: selectedMaximum)
    }
}
