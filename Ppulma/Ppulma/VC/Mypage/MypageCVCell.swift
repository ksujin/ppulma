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
   
    func configure(data : String) {
       myImgView.setImgWithKF(url: data, defaultImg: #imageLiteral(resourceName: "aimg"))
    }

    override func awakeFromNib() {
        myImgView.makeRounded(cornerRadius: myImgView.frame.height/2)
        myImgView.makeViewBorder(width: 1, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
    }
}
