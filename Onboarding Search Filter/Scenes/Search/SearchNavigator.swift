//
//  SearchNavigator.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import UIKit
import RxCocoa

public class SearchNavigator {
    
    private let navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    public func openFilter(filterRelay: BehaviorRelay<Filter>) {
        let viewController = FilterViewController(filterRelay: filterRelay)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
