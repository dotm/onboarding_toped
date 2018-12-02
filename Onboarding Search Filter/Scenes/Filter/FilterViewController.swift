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
    
    private let disposeBag = DisposeBag()
    private var viewModel: FilterViewModel
    
    public init(filterObject: Filter) {
        viewModel = FilterViewModel(filter: filterObject)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        bindViewModel()
    }
    
    private func setupNavBar() {
        title = "Filter"
    }
    
    private func bindViewModel() {
        
    }
}
