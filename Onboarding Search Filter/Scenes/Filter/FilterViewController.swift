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

    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var wholeSaleSwitch: UISwitch!
    @IBOutlet weak var shopTypeButton: UIButton!
    @IBOutlet weak var goldMerchantView: UIView!
    @IBOutlet weak var goldMerchantButton: UIButton!
    @IBOutlet weak var officialStoreView: UIView!
    @IBOutlet weak var officialStoreButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: FilterViewModel
    
    public init(filterObject: Filter) {
        viewModel = FilterViewModel(filter: filterObject)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    let newFilterTrigger = PublishSubject<Filter>()

    private let filterSubject = PublishSubject<Filter>()
    public var filterTrigger: Driver<Filter> {
        return filterSubject.asDriver(onErrorRecover: { _ -> Driver<Filter> in
            return .empty()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        bindViewModel()
    }
    
    private func bindViewModel() {
        let newFilterDriver = newFilterTrigger.asDriver { error -> Driver<Filter> in
            return .empty()
        }

        let input = FilterViewModel.Input(
            viewDidLoadTrigger: Driver.just(()),
            wholeSaleTrigger: wholeSaleSwitch.rx.isOn.asDriver(),
            resetTrigger: resetButton.rx.tap.asDriver(),
            applyTrigger: applyButton.rx.tap.asDriver(),
            shopTypeTrigger: shopTypeButton.rx.tap.asDriver(),
            goldMerchantTrigger: goldMerchantButton.rx.tap.asDriver(),
            officialStoreTrigger: officialStoreButton.rx.tap.asDriver(),
            newFilterTrigger: newFilterDriver
        )
        
        let output = viewModel.transform(input: input)
        
        output.wholeSaleChanged
            .drive(wholeSaleSwitch.rx.isOn)
            .disposed(by: disposeBag)

        output.toggleReset
            .drive(resetButton.rx.isHidden)
            .disposed(by: disposeBag)
        
//        output.shopTypeTapped
//            .drive(onNext: { (filter) in
//                let shopFilterVC = ShopFilterViewController(filterObject: filter)
//                self.navigationController?.pushViewController(shopFilterVC, animated: true)
//            })
//            .disposed(by: disposeBag)
        
        output.shopTypeTapped.flatMapLatest { (filter) -> Driver<Filter> in
            let shopFilterVC = ShopFilterViewController(filterObject: filter)
            self.navigationController?.pushViewController(shopFilterVC, animated: true)
            return shopFilterVC.filterTrigger
        }
        .drive(newFilterTrigger)
        .disposed(by: disposeBag)
        
        output.applyTapped
            .drive(onNext: { [weak self] filter in
                self?.filterSubject.onNext(filter)
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        output.showGoldMerchant.drive(goldMerchantView.rx.isHidden).disposed(by: disposeBag)
        output.showOfficialStore.drive(officialStoreView.rx.isHidden).disposed(by: disposeBag)

        closeButton.rx
            .tap
            .asDriver()
            .drive(onNext: { _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}
