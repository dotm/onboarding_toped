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

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var goldMerchantButton: UIButton!
    @IBOutlet weak var officialStoreButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    private let disposeBag = DisposeBag()
    let viewModel: ShopFilterViewModel
    
    private let filterSubject = PublishSubject<Filter>()
    public var filterTrigger: Driver<Filter> {
        return filterSubject.asDriver(onErrorRecover: { _ -> Driver<Filter> in
            return .empty()
        })
    }
    
    public init(filterObject: Filter) {
        viewModel = ShopFilterViewModel(filter: filterObject)
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
        let input = ShopFilterViewModel.Input(
            goldButtonTrigger: goldMerchantButton.rx.tap.asDriver(),
            officialButtonTrigger: officialStoreButton.rx.tap.asDriver(),
            applyTrigger: applyButton.rx.tap.asDriver(),
            resetTrigger: resetButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isGoldChecked.drive(onNext: { [weak self] isChecked in
            self?.goldMerchantButton.backgroundColor = isChecked ? .green : .lightGray
        }).disposed(by: disposeBag)
        
        output.isOfficialChecked.drive(onNext: { [weak self] isChecked in
            self?.officialStoreButton.backgroundColor = isChecked ? .green : .lightGray
        }).disposed(by: disposeBag)
        
        output.applyTapped.drive(onNext: { [weak self] (filter) in
            self?.filterSubject.onNext(filter)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        output.isShowReset.drive(resetButton.rx.isHidden).disposed(by: disposeBag)
        
        closeButton.rx
            .tap
            .asDriver()
            .drive(onNext: { (_) in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }

}
