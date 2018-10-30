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
        let title: Driver<String>
        let price: Driver<String>
        let url: Driver<URL?>
    }
    
    func transform(input: SearchCellViewModel.Input) -> SearchCellViewModel.Output {
        let product = Driver.just(self.product)
        
        let title = product.map { (product) -> String in
            return product.name ?? ""
        }
        
        let price = product.map { (product) -> String in
            return product.price ?? ""
        }
        
        let url = product.map { (product) -> URL? in
            return URL(string: product.imageURLString!)
        }
        return Output(title: title, price: price, url: url)
    }
}
