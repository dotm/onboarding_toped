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
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        closeButton.rx
            .tap
            .asDriver()
            .drive(onNext: { (_) in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }

}
