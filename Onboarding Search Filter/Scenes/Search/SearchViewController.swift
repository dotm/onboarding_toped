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
    
    // IBOutlet UICollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    // IBOutlet filter button
    @IBOutlet weak var filterButton: UIButton!

    
    private let disposeBag = DisposeBag()
    private var viewModel: SearchViewModel
    let newFilterTrigger = PublishSubject<Filter>()

    public init() {
        viewModel = SearchViewModel(filter: Filter(), useCase: DefaultSearchUseCase())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
        
    }

    private func bindViewModel() {
        let loadMoreTrigger = collectionView.rxReachedBottom.asDriver { (error) -> Driver<Void> in
            return .empty()
        }
        
        let newFilterDriver = newFilterTrigger.asDriver { error -> Driver<Filter> in
            return .empty()
        }
        
        let input = SearchViewModel.Input(viewDidLoadTrigger: Driver.just(()),
                                          loadMoreTrigger: loadMoreTrigger,
                                          filterButtonTapTrigger: filterButton.rx.tap.asDriver(),
                                          newFilterTrigger: newFilterDriver)
        
        let output = viewModel.transform(input: input)
        
        output.searchList.drive(collectionView.rx.items(cellIdentifier: "SearchCollectionViewCell", cellType: SearchCollectionViewCell.self)) {
            _, viewModel, cell in
            cell.bind(product: viewModel)
        }.disposed(by: disposeBag)
        
        output.openFilter
            .flatMapLatest { [weak self] (filter) -> Driver<Filter> in     
                let filterVC = FilterViewController(filterObject: filter)
                let navigationController = UINavigationController(rootViewController: filterVC)
                self?.navigationController?.present(navigationController, animated: true, completion: nil)
                return filterVC.filterTrigger
        }
        .drive(newFilterTrigger)
        .disposed(by: disposeBag)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width / 2) - 2
        let height: CGFloat = ((view.frame.width / 2) - 2) + 100
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    }
}
