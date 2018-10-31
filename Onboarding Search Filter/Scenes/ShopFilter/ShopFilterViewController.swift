//
//  ShopFilterViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 08/10/18.
//

import UIKit
import RxCocoa
import RxSwift

class ShopFilterViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let identifier = "shopViewTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ShopViewTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.rowHeight = 60
        bindViewModel()
    }
    
    private func bindViewModel() {
        closeButton.rx
            .tap
            .asDriver()
            .drive(onNext: { (_) in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
}

extension ShopFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ShopViewTableViewCell
        return cell
    }
}
