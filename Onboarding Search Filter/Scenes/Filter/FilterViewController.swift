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
    @IBOutlet weak var shopTypeButton: NSLayoutConstraint!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var wholeSaleSwitch: UISwitch!
    
    private let disposeBag = DisposeBag()
    var filterObject = Filter()
    let filterSubject = PublishSubject<Filter>()
    public var filterTrigger: Driver<Filter> {
        return filterSubject.asDriver(onErrorJustReturn: filterObject)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        wholeSaleSwitch.isOn = filterObject.wholesale
        bindViewModel()
    }
    
    private func bindViewModel() {
        closeButton.rx
            .tap
            .asDriver()
            .drive(onNext: { _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)

        let applyTap = applyButton.rx.tap.asDriver()
        applyTap.drive(onNext: { (_) in
            self.filterObject.start = 0
            self.filterSubject.onNext(self.filterObject)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        let switchChanged = wholeSaleSwitch.rx.isOn.asDriver()
        switchChanged.drive(onNext: { [weak self] (isOn) in
            guard let self = self else { return }
            self.filterObject.wholesale = isOn
            self.resetButton.isHidden = !isOn
        }).disposed(by: disposeBag)
    }
}
