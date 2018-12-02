//
//  SearchCellViewModel.swift
//  Onboarding Search Filter
//
//  Created by nakama on 29/10/18.
//

import Foundation
import RxSwift
import RxCocoa

class SearchCellViewModel: ViewModelType {
    private let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    struct Input {
        
    }
    
    struct Output {
    }
    
    func transform(input: SearchCellViewModel.Input) -> SearchCellViewModel.Output {
        return Output()
    }
}
