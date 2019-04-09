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
    private weak var slider: TTRangeSlider!
    
    private let disposeBag = DisposeBag()
    private var viewModel: FilterViewModel
    private var handleApplyFilter: (Filter)->()
    
    public init(filterObject: Filter, handleApplyFilter: @escaping (Filter)->()) {
        viewModel = FilterViewModel(filter: filterObject)
        self.handleApplyFilter = handleApplyFilter
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
            self?.slider.selectedMinimum = value
        }).disposed(by: disposeBag)
        output.selectedMaximum.drive(onNext: { [weak self] (value) in
            self?.slider.selectedMaximum = value
        }).disposed(by: disposeBag)
        
        slider.rx.controlEvent(UIControlEvents.valueChanged)
            .subscribe(onNext: { [weak self] (_) in
                print(self?.slider.selectedMinimum ?? 0, self?.slider.selectedMaximum ?? 0)
            }).disposed(by: disposeBag)
    }
    private func setupLayout(){
        setupNavBar()
        setupSlider()
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
        self.dismiss(animated: true, completion: nil)
    }
    private func setupSlider() {
        let slider = sliderFactory()
        view.addSubview(slider)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        slider.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        
        self.slider = slider
    }
    private func sliderFactory() -> TTRangeSlider {
        let slider = TTRangeSlider(frame: .zero)
        slider.minValue = 0
        slider.maxValue = 10_000_000
        slider.enableStep = true
        slider.step = 1000
        
        return slider
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
        let pmin = Int(slider.selectedMinimum)
        let pmax = Int(slider.selectedMaximum)
        let newFilter = Filter(pmin: pmin, pmax: pmax)
        handleApplyFilter(newFilter)
        closePage()
    }
}
