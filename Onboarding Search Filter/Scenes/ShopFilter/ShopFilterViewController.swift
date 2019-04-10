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
    
    private let disposeBag = DisposeBag()
    let viewModel: ShopFilterViewModel
    
    public init(filterObject: Filter) {
        viewModel = ShopFilterViewModel(filter: filterObject)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        bindViewModel()
    }
    private func setupNavBar() {
        self.navigationItem.title = "Shop Type"
        self.navigationItem.leftBarButtonItem = closeButton
    }
    private var closeButton: UIBarButtonItem {
        let button = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closePage))
        button.tintColor = .gray
        return button
    }
    @objc private func closePage(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func bindViewModel() {
        
    }

}
