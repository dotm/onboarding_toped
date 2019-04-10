//
//  ShopFilterViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import UIKit
import RxCocoa
import RxSwift
import SimpleCheckbox

class ShopFilterViewController: UIViewController {
    private weak var goldMerchantCheckboxRow: UIView!
    private weak var goldMerchantCheckbox: Checkbox!
    private weak var officialStoreCheckbox: Checkbox!
    private weak var applyFilterButton: UIButton!
    
    private let disposeBag = DisposeBag()
    let viewModel: ShopFilterViewModel
    private let initialFilter: Filter
    private var handleApplyFilter: (Filter)->()
    
    public init(filterObject: Filter, handleApplyFilter: @escaping (Filter)->()) {
        viewModel = ShopFilterViewModel(filter: filterObject)
        self.handleApplyFilter = handleApplyFilter
        initialFilter = filterObject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupLayout()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let setupFilterSubject = PublishSubject<Filter>()
        if let resetButton = self.navigationItem.rightBarButtonItem {
            let resetFilterDriver = resetButton.rx.tap.asDriver()
            resetFilterDriver
                .drive(onNext: { [weak self] () in
                    guard let self = self else {return}
                    setupFilterSubject.onNext(self.initialFilter)
                })
                .disposed(by: disposeBag)
        }
        
        let goldMerchantTagTrigger = goldMerchantCheckbox.rx.controlEvent(.valueChanged).asDriver()
            .map { [weak self] () -> Bool in
                guard let self = self else {return false}
                return self.goldMerchantCheckbox.isChecked
            }
        let officialStoreTagTrigger = officialStoreCheckbox.rx.controlEvent(.valueChanged).asDriver()
            .map { [weak self] () -> Bool in
                guard let self = self else {return false}
                return self.officialStoreCheckbox.isChecked
            }
        let input = ShopFilterViewModel.Input(
            setupFilter: setupFilterSubject.asDriver(onErrorJustReturn: initialFilter),
            goldMerchantTagTrigger: goldMerchantTagTrigger,
            officialStoreTagTrigger: officialStoreTagTrigger
        )
        
        let output = viewModel.transform(input: input)
        output.setupFilter.drive(onNext: { [weak self] (filter) in
            guard let self = self else {return}
            self.goldMerchantCheckbox.isChecked = filter.fshop == Filter.GOLD_MERCHANT_FSHOP_TAG
            self.officialStoreCheckbox.isChecked = filter.official
        }).disposed(by: disposeBag)
        output.goldMerchantSelected.drive(onNext: { [weak self] (value) in
            self?.goldMerchantCheckbox.isChecked = value
        }).disposed(by: disposeBag)
        output.officialStoreSelected.drive(onNext: { [weak self] (value) in
            self?.officialStoreCheckbox.isChecked = value
        }).disposed(by: disposeBag)
        
        let applyFilterTrigger = applyFilterButton.rx.tap.asDriver()
        applyFilterTrigger.flatMapLatest({ (_) -> Driver<Filter> in
            return output.filter
        }).drive(onNext: { [weak self] (newFilter) in
            self?.handleApplyFilter(newFilter)
            self?.closePage()
        }).disposed(by: disposeBag)
        
        setupFilterSubject.onNext(initialFilter)
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Shop Type"
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = .tpGreen
    }
    private var closeButton: UIBarButtonItem {
        let button = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closePage))
        button.tintColor = .gray
        return button
    }
    @objc private func closePage(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupLayout() {
        setupGoldMerchantCheckboxRow()
        setupOfficialStore(previousElement: goldMerchantCheckboxRow)
        setupApplyButton()
    }
    private func setupGoldMerchantCheckboxRow() {
        let goldMerchantCheckboxRow = UITableViewCell(style: .value1, reuseIdentifier: "gold merchant row")
        goldMerchantCheckboxRow.textLabel?.text = "Gold Merchant"
        goldMerchantCheckboxRow.backgroundColor = .white
        view.addSubview(goldMerchantCheckboxRow)
        
        goldMerchantCheckboxRow.translatesAutoresizingMaskIntoConstraints = false
        goldMerchantCheckboxRow.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        goldMerchantCheckboxRow.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        goldMerchantCheckboxRow.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        goldMerchantCheckboxRow.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(50)).isActive = true
        
        self.goldMerchantCheckboxRow = goldMerchantCheckboxRow
        
        let goldMerchantCheckbox = Checkbox()
        goldMerchantCheckbox.checkedBorderColor = .black
        goldMerchantCheckbox.uncheckedBorderColor = .tpGreen
        goldMerchantCheckbox.checkmarkColor = .tpGreen
        goldMerchantCheckbox.checkmarkStyle = .square
        goldMerchantCheckboxRow.addSubview(goldMerchantCheckbox)
        
        goldMerchantCheckbox.translatesAutoresizingMaskIntoConstraints = false
        goldMerchantCheckbox.widthAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
        goldMerchantCheckbox.heightAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
        goldMerchantCheckbox.centerYAnchor.constraint(equalTo: goldMerchantCheckboxRow.centerYAnchor).isActive = true
        goldMerchantCheckbox.trailingAnchor.constraint(equalTo: goldMerchantCheckboxRow.trailingAnchor, constant: -CGFloat(20)).isActive = true
        
        self.goldMerchantCheckbox = goldMerchantCheckbox
    }
    private func setupOfficialStore(previousElement: UIView) {
        let officialStoreCheckboxRow = UITableViewCell(style: .value1, reuseIdentifier: "official store row")
        officialStoreCheckboxRow.textLabel?.text = "Official Store"
        officialStoreCheckboxRow.backgroundColor = .white
        view.addSubview(officialStoreCheckboxRow)
        
        officialStoreCheckboxRow.translatesAutoresizingMaskIntoConstraints = false
        officialStoreCheckboxRow.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        officialStoreCheckboxRow.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        officialStoreCheckboxRow.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        officialStoreCheckboxRow.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(50)).isActive = true
        
        let officialStoreCheckbox = Checkbox()
        officialStoreCheckbox.checkedBorderColor = .black
        officialStoreCheckbox.uncheckedBorderColor = .tpGreen
        officialStoreCheckbox.checkmarkColor = .tpGreen
        officialStoreCheckbox.checkmarkStyle = .square
        officialStoreCheckboxRow.addSubview(officialStoreCheckbox)
        
        officialStoreCheckbox.translatesAutoresizingMaskIntoConstraints = false
        officialStoreCheckbox.widthAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
        officialStoreCheckbox.heightAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
        officialStoreCheckbox.centerYAnchor.constraint(equalTo: officialStoreCheckboxRow.centerYAnchor).isActive = true
        officialStoreCheckbox.trailingAnchor.constraint(equalTo: officialStoreCheckboxRow.trailingAnchor, constant: -CGFloat(20)).isActive = true
        
        self.officialStoreCheckbox = officialStoreCheckbox
    }

    private func setupApplyButton(){
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .tpGreen
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.applyFilterButton = button
    }
}
