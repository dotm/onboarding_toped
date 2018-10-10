//
//  ShopFilterViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import UIKit
import RxCocoa
import RxSwift

class ShopFilterViewController: UIViewController {
    
    private let filterRelay: BehaviorRelay<Filter>
    private var viewModel = ShopFilterViewModel()
    
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
        // use self.filterRelay
    }
    
}
