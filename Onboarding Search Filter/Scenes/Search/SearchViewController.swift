//
//  SearchViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

// access control
public class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel: SearchViewModel

    public init() {
        viewModel = SearchViewModel(filter: Filter(), useCase: DefaultSearchUseCase())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    private func setupUI() {
        
    }

    private func bindViewModel() {
    }
}
