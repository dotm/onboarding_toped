//
//  FilterViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import UIKit
import RxCocoa
import RxSwift

class FilterViewController: UIViewController {
    
    // minimum price label
    // maximum price label
    // slider (Tokopedia's)
    // whole sale switch
    // shop type button
    // gold merchant filter view
    // official store filter view
    // reset button
    // apply button
    
    private let filterRelay: BehaviorRelay<Filter>
    
    private lazy var navigator: FilterNavigator = {
        let nv = FilterNavigator(navigationController: self.navigationController)
        return nv
    }()
    
    private var viewModel = FilterViewModel()
    
    public init(filterRelay: BehaviorRelay<Filter>) {
        self.filterRelay = filterRelay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        // use self.filterRelay, filterRelay.accept if button apply tapped
        // shop type button navigate using navigator.openShopFilter, pass the filterRelay

    }

}
