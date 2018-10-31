//
//  MypageCVCell.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MypageCVCell: UICollectionViewCell {
    @IBOutlet weak var myImgView: UIImageView!
   
    func configure(data : UIImage) {
        myImgView.image = data
    }

    override func awakeFromNib() {
        myImgView.makeRounded(cornerRadius: 37)
    }
}
