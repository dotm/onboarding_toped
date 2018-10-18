//
//  SearchViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import UIKit
import RxCocoa
import RxDataSources

// access control
public class SearchViewController: UIViewController {
    
    // IBOutlet UICollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    // IBOutlet filter button
    @IBOutlet weak var filterButtom: UIButton!
    
    private var viewModel = SearchViewModel()
    
    private var filterRelay = BehaviorRelay<Filter>(value: Filter())

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 1
//        layout.minimumInteritemSpacing = 0
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.addBackgroundColor(color: .backgroundGrey)
//        return cv
//    }()

    private func bindViewModel() {
        // bind filterRelay
        let input = SearchViewModel.Input(viewDidloadTrigger: Driver.just(()))
        let output = viewModel.transform(input: input)
        // paging use this as trigger -> collectionView.rx.rxReachedBottom (Tokopedia's)

        // filter button -> present filter view controller
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "test")
        
    }

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath) as! SearchCollectionViewCell
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width / 2) - 2
        let height: CGFloat = ((view.frame.width / 2) - 2) + 100
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    }
}
