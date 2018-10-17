//
//  SearchViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import UIKit
import RxCocoa
import RxDataSources

// access control
public class SearchViewController: UIViewController {
    
    // IBOutlet UICollectionView
    // IBOutlet filter button
    
    private var viewModel = SearchViewModel()
    
    private var filterRelay = BehaviorRelay<Filter>(value: Filter())

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }

    private func bindViewModel() {
        // bind filterRelay
        // paging use this as trigger -> collectionView.rx.rxReachedBottom (Tokopedia's)
        // filter button -> present filter view controller
    }

}
