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
    private weak var applyFilterButton: UIButton!
    
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
        setupLayout()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
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
