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
    private weak var priceLabelsView: UIView!
    private weak var minimumPriceTextField: UITextField!
    private weak var maximumPriceTextField: UITextField!
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
        
        self.hideKeyboard()
        setupLayout()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let viewDidLoadTrigger = Driver.just(())
        
        let minimumPriceTextFieldChanged = minimumPriceTextField.rx.controlEvent(.editingDidEnd)
            .map{ [weak self] () -> Float in
                let lowerValue = Float(self?.minimumPriceTextField.text ?? "0") ?? 0
                return lowerValue
            }.asDriver(onErrorJustReturn: 0)
        let maximumPriceTextFieldChanged = maximumPriceTextField.rx.controlEvent(.editingDidEnd)
            .map{ [weak self] () -> Float in
                let higherValue = Float(self?.maximumPriceTextField.text ?? "0") ?? 0
                return higherValue
            }.asDriver(onErrorJustReturn: 0)
        
        let priceSliderChanged = priceSlider.rx.controlEvent(.valueChanged)
            .map{ [weak self] () -> (Float, Float) in
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
            minimumPriceTextFieldChanged: minimumPriceTextFieldChanged,
            maximumPriceTextFieldChanged: maximumPriceTextFieldChanged,
            priceSliderChanged: priceSliderChanged,
            wholeSaleFilterChanged: wholeSaleFilterChanged
        )
        
        let output = viewModel.transform(input: input)
        output.minimumPriceText.drive(minimumPriceTextField.rx.text)
            .disposed(by: disposeBag)
        output.maximumPriceText.drive(maximumPriceTextField.rx.text)
            .disposed(by: disposeBag)
        output.selectedMinimum.drive(onNext: { [weak self] (value) in
            self?.priceSlider.selectedMinimum = value
            self?.minimumPriceTextField.text = String(Int(value))
        }).disposed(by: disposeBag)
        output.selectedMaximum.drive(onNext: { [weak self] (value) in
            self?.priceSlider.selectedMaximum = value
            self?.maximumPriceTextField.text = String(Int(value))
        }).disposed(by: disposeBag)
        output.wholesaleSwitch.drive(wholesaleSwitch.rx.isOn)
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
        setupPriceSlider(previousElement: priceLabelsView)
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
        let margin = CGFloat(10)
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: CGFloat(50) + margin).isActive = true
        
        self.priceLabelsView = containerView
        
        let minimumPriceLabel = UILabel()
        minimumPriceLabel.text = "Min. Price (IDR)"
        containerView.addSubview(minimumPriceLabel)
        
        minimumPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        minimumPriceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: margin).isActive = true
        minimumPriceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin).isActive = true
        minimumPriceLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        minimumPriceLabel.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor).isActive = true
        
        let minimumPriceTextField = UITextField()
        minimumPriceTextField.keyboardType = .numberPad
        containerView.addSubview(minimumPriceTextField)
        
        minimumPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        minimumPriceTextField.topAnchor.constraint(equalTo: minimumPriceLabel.bottomAnchor).isActive = true
        minimumPriceTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin).isActive = true
        minimumPriceTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        minimumPriceTextField.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        self.minimumPriceTextField = minimumPriceTextField
        
        let maximumPriceLabel = UILabel()
        maximumPriceLabel.textAlignment = .right
        maximumPriceLabel.text = "Max. Price (IDR)"
        view.addSubview(maximumPriceLabel)
        
        maximumPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        maximumPriceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: margin).isActive = true
        maximumPriceLabel.leadingAnchor.constraint(equalTo: minimumPriceLabel.trailingAnchor).isActive = true
        maximumPriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin).isActive = true
        maximumPriceLabel.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor).isActive = true
        
        let maximumPriceTextField = UITextField()
        maximumPriceTextField.keyboardType = .numberPad
        maximumPriceTextField.textAlignment = .right
        containerView.addSubview(maximumPriceTextField)
        
        maximumPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        maximumPriceTextField.topAnchor.constraint(equalTo: maximumPriceLabel.bottomAnchor).isActive = true
        maximumPriceTextField.leadingAnchor.constraint(equalTo: minimumPriceTextField.trailingAnchor).isActive = true
        maximumPriceTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin).isActive = true
        maximumPriceTextField.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        
        self.maximumPriceTextField = maximumPriceTextField
    }
    
    private func setupPriceSlider(previousElement: UIView) {
        let priceSlider = priceSliderFactory()
        priceSlider.backgroundColor = .white
        view.addSubview(priceSlider)
        
        priceSlider.translatesAutoresizingMaskIntoConstraints = false
        priceSlider.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        priceSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        priceSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        priceSlider.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        
        self.priceSlider = priceSlider
    }
    private func priceSliderFactory() -> TTRangeSlider {
        let priceSlider = TTRangeSlider(frame: .zero)
        priceSlider.minValue = 0
        priceSlider.maxValue = 10_000_000
        priceSlider.selectedMinimum = Float(initialFilter.pmin)
        priceSlider.selectedMaximum = Float(initialFilter.pmax)
        priceSlider.enableStep = true
        priceSlider.step = 1000
        priceSlider.tintColor = .gray
        priceSlider.tintColorBetweenHandles = .tpGreen
//        priceSlider.minLabelColour = .tpGreen
//        priceSlider.maxLabelColour = .tpGreen
        priceSlider.hideLabels = true
        priceSlider.handleColor = .white
        priceSlider.handleBorderColor = .tpGreen
        priceSlider.handleBorderWidth = CGFloat(1)
        
        return priceSlider
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

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
