//
//  ShopViewTableViewCell.swift
//  Onboarding Search Filter
//
//  Created by nakama on 31/10/18.
//

import UIKit

class ShopViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var title: UILabel!
    
    func bind(shopTypes: ShopTypes) {
        checkView.backgroundColor = shopTypes.isActive! ? .green : .gray
        title.text = shopTypes.title
    }
    
}
