//
//  SearchCollectionViewCell.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 09/10/18.
//

import UIKit
import RxSwift
import RxCocoa

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        price.textColor = .tpOrange
    }
    
    func bind(product: Product) {
        let viewModel = SearchCellViewModel(product: product)
        let output = viewModel.transform(input: SearchCellViewModel.Input())
        
        output.title.drive(title.rx.text).disposed(by: disposeBag)
        output.price.drive(price.rx.text).disposed(by: disposeBag)
        
        output.url.drive(onNext: { (url) in
            let data = try? Data(contentsOf: url!)
            self.imageView.image = UIImage(data: data!)
        }).disposed(by: disposeBag)
    }
}
