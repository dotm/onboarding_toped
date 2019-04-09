//
//  FilterViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import UIKit
import RxCocoa
import RxSwift
import TTRangeSlider

class FilterViewController: UIViewController {
    private weak var priceSlider: TTRangeSlider!
    private weak var wholesaleSwitch: UISwitch!
    
    private let disposeBag = DisposeBag()
    private var viewModel: FilterViewModel
    private var handleApplyFilter: (Filter)->()
    private var didClose: (()->())?
    
    public init(filterObject: Filter, handleApplyFilter: @escaping (Filter)->(), didClose: (()->())? = nil) {
        viewModel = FilterViewModel(filter: filterObject)
        self.handleApplyFilter = handleApplyFilter
        self.didClose = didClose
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: FilterViewModel.Input())
        output.selectedMinimum.drive(onNext: { [weak self] (value) in
            self?.priceSlider.selectedMinimum = value
        }).disposed(by: disposeBag)
        output.selectedMaximum.drive(onNext: { [weak self] (value) in
            self?.priceSlider.selectedMaximum = value
        }).disposed(by: disposeBag)
        output.wholesaleSwitch.drive(onNext: { [weak self] (value) in
            self?.wholesaleSwitch.setOn(value, animated: false)
        }).disposed(by: disposeBag)
        
        priceSlider.rx.controlEvent(UIControlEvents.valueChanged)
            .subscribe(onNext: { [weak self] (_) in
                print(self?.priceSlider.selectedMinimum ?? 0, self?.priceSlider.selectedMaximum ?? 0)
            }).disposed(by: disposeBag)
        wholesaleSwitch.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] (v) in
                print(self?.wholesaleSwitch.isOn)
            }).disposed(by: disposeBag)
    }
    private func setupLayout(){
        setupNavBar()
        setupPriceSlider()
        setupWholesaleFilter(previousElement: priceSlider)
        setupApplyButton()
    }
    private func setupNavBar() {
        self.navigationItem.title = "Filter"
        self.navigationItem.leftBarButtonItem = closeButton
    }
    private var closeButton: UIBarButtonItem {
        let button = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closePage))
        button.tintColor = .gray
        return button
    }
    @objc private func closePage(){
        self.dismiss(animated: true, completion: didClose)
    }
    
    private func setupPriceSlider() {
        let priceSlider = priceSliderFactory()
        view.addSubview(priceSlider)
        
        priceSlider.translatesAutoresizingMaskIntoConstraints = false
        priceSlider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        priceSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        priceSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        priceSlider.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        
        self.priceSlider = priceSlider
    }
    private func priceSliderFactory() -> TTRangeSlider {
        let priceslider = TTRangeSlider(frame: .zero)
        priceslider.minValue = 0
        priceslider.maxValue = 10_000_000
        priceslider.enableStep = true
        priceslider.step = 1000
        
        return priceslider
    }
    
    private func setupWholesaleFilter(previousElement: UIView){
        let containerView = UITableViewCell(style: .value1, reuseIdentifier: "wholesale filter")
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        //set constraint
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        //set cell properties
        containerView.textLabel?.text = "Whole Sale"
        
        let wholesaleSwitch = UISwitch()
        containerView.accessoryView = wholesaleSwitch
        self.wholesaleSwitch = wholesaleSwitch
    }
    
    private func setupApplyButton(){
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .tpGreen
        button.addTarget(self, action: #selector(applyFilter_andClosePage), for: .touchUpInside)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    @objc private func applyFilter_andClosePage(){
        let pmin = Int(priceSlider.selectedMinimum)
        let pmax = Int(priceSlider.selectedMaximum)
        let wholesale = wholesaleSwitch.isOn
        let newFilter = Filter(pmin: pmin, pmax: pmax, wholesale: wholesale)
        handleApplyFilter(newFilter)
        closePage()
    }
}
