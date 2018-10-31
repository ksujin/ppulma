//
//  SearchResultCVCell.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 27..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchResultCVCell: UICollectionViewCell {
    @IBOutlet weak var itemImgView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    func configure(data : SearchVOResult){
        itemImgView.setImgWithKF(url: data.imgURL, defaultImg: #imageLiteral(resourceName: "aimg"))
        titleLbl.text = data.name
        priceLbl.text = data.price.description
    }
    override func awakeFromNib() {
        self.makeCornerRound(cornerRadius: 7)
    }
}
