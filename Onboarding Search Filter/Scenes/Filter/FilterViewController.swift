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
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: FilterViewModel
    
    public init(filterObject: Filter) {
        viewModel = FilterViewModel(filter: filterObject)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

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
        let input = FilterViewModel.Input(
            wholeSaleTrigger: wholeSaleSwitch.rx.isOn.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.wholeSaleChanged
            .drive(wholeSaleSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        output.filterOutput.drive(onNext: { (filter) in
            self.filterObject = filter
        }).disposed(by: disposeBag)

        closeButton.rx
            .tap
            .asDriver()
            .drive(onNext: { _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        let shopTap = shopTypeButton.rx.tap.asDriver()
        shopTap.drive(onNext: { _ in
            self.navigationController?.pushViewController(ShopFilterViewController(), animated: true)
        }).disposed(by: disposeBag)
        

        let applyTap = applyButton.rx.tap.asDriver()
        applyTap.drive(onNext: { (_) in
            self.filterSubject.onNext(self.filterObject)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
