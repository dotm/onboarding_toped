//
//  SearchViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

// access control
public class SearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: SearchViewModel
    
    private let newFilterSubject = PublishSubject<Filter>()

    public init() {
        viewModel = SearchViewModel(filter: Filter(), useCase: DefaultSearchUseCase())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    private func setupUI() {
        title = "Search"
        filterButton.backgroundColor = .tpGreen
        self.navigationController?.navigationBar.isTranslucent = false
        
        let width = (view.frame.width - 1) / 2
        let height = width + 80
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
    }

    private func bindViewModel(){
        let loadMoreTrigger = collectionView.rxReachedBottom.asDriver { (error) -> Driver<Void> in
            return .empty()
        }
        
        let input = SearchViewModel.Input(
            viewDidLoadTrigger: Driver.just(()),
            loadMoreTrigger: loadMoreTrigger,
            filterButtonTapTrigger: filterButton.rx.tap.asDriver(),
            newFilterTrigger: newFilterSubject.asDriver{error in Driver.empty()}
        )
        
        let output = viewModel.transform(input: input)
        
        output.searchList.drive(
            collectionView.rx.items(cellIdentifier: "SearchCollectionViewCell", cellType: SearchCollectionViewCell.self)
        ) {
            _, viewModel, cell in
            cell.bind(product: viewModel)
            }.disposed(by: disposeBag)
        
        output.openFilter.drive(onNext: { [weak self] filter in
            guard let self = self else {return}
            let filterVC = FilterViewController(
                filterObject: filter,
                didClose: { [weak self] in
                    self?.collectionView.setContentOffset(.zero, animated: true) //scroll to top
                }
            )
            filterVC.saveTriggerDriver.drive(self.newFilterSubject).disposed(by: self.disposeBag)
            let navigationController = UINavigationController(rootViewController: filterVC)
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

}
