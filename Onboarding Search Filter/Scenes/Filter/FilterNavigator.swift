//
//  FilterNavigator.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import RxCocoa
import UIKit

public class FilterNavigator {
    
    private let navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    public func openShopFilter(filterRelay: BehaviorRelay<Filter>) {
        let viewController = ShopFilterViewController(filterRelay: filterRelay)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
