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
    private weak var minimumPriceLabel: UILabel!
    private weak var maximumPriceLabel: UILabel!
    private weak var priceSlider: TTRangeSlider!
    private weak var wholesaleSwitch: UISwitch!
    private weak var applyFilterButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: FilterViewModel
    private var handleApplyFilter: (Filter)->()
    private var didClose: (()->())?
    private let initialFilter: Filter
    
    public init(filterObject: Filter, handleApplyFilter: @escaping (Filter)->(), didClose: (()->())? = nil) {
        viewModel = FilterViewModel(filter: filterObject)
        self.handleApplyFilter = handleApplyFilter
        self.didClose = didClose
        self.initialFilter = filterObject
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
        let viewDidLoadTrigger = Driver.just(())
        
        let priceSliderChanged = priceSlider.rx.controlEvent(.valueChanged)
            .map{ [weak self] () -> (lowerValue: Float, higherValue: Float) in
                return (
                    self?.priceSlider.selectedMinimum ?? 0,
                    self?.priceSlider.selectedMaximum ?? 0
                )
            }
            .asDriver(onErrorJustReturn: (lowerValue: 0, higherValue: 0))
        let wholeSaleFilterChanged = wholesaleSwitch.rx.controlEvent(.valueChanged)
            .map { [weak self] _ -> Bool in
                return self?.wholesaleSwitch.isOn ?? false
            }
            .asDriver(onErrorJustReturn: false)
        
        let input = FilterViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger,
            priceSliderChanged: priceSliderChanged,
            wholeSaleFilterChanged: wholeSaleFilterChanged
        )
        
        let output = viewModel.transform(input: input)
        output.minimumPriceText.drive(minimumPriceLabel.rx.text)
            .disposed(by: disposeBag)
        output.maximumPriceText.drive(maximumPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        let applyFilterTrigger = applyFilterButton.rx.tap.asDriver()
        applyFilterTrigger.flatMapLatest({ (_) -> Driver<Filter> in
            return output.filter
        }).drive(onNext: { [weak self] (newFilter) in
            self?.handleApplyFilter(newFilter)
            self?.closePage()
        }).disposed(by: disposeBag)
    }
    private func setupLayout(){
        setupNavBar()
        setupPriceLabels()
        setupPriceSlider(previousElement: maximumPriceLabel)
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
    private func setupPriceLabels() {
        let minimumPriceLabel = UILabel()
        minimumPriceLabel.text = "Min. Price: Rp 100.000,-"
        view.addSubview(minimumPriceLabel)
        
        minimumPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        minimumPriceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        minimumPriceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        minimumPriceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        minimumPriceLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        
        self.minimumPriceLabel = minimumPriceLabel
        
        let maximumPriceLabel = UILabel()
        maximumPriceLabel.text = "Max. Price: Rp 1.000.000,-"
        view.addSubview(maximumPriceLabel)
        
        maximumPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        maximumPriceLabel.topAnchor.constraint(equalTo: minimumPriceLabel.bottomAnchor).isActive = true
        maximumPriceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        maximumPriceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        maximumPriceLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        
        self.maximumPriceLabel = maximumPriceLabel
    }
    
    private func setupPriceSlider(previousElement: UIView) {
        let priceSlider = priceSliderFactory()
        view.addSubview(priceSlider)
        
        priceSlider.translatesAutoresizingMaskIntoConstraints = false
        priceSlider.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        priceSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        priceSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        priceSlider.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        
        self.priceSlider = priceSlider
    }
    private func priceSliderFactory() -> TTRangeSlider {
        let priceslider = TTRangeSlider(frame: .zero)
        priceslider.minValue = 0
        priceslider.maxValue = 10_000_000
        priceslider.selectedMinimum = Float(initialFilter.pmin)
        priceslider.selectedMaximum = Float(initialFilter.pmax)
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
        wholesaleSwitch.setOn(initialFilter.wholesale, animated: false)
        containerView.accessoryView = wholesaleSwitch
        self.wholesaleSwitch = wholesaleSwitch
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
