//
//  MagazineFirstCVCell.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MagazineFirstCVCell: UICollectionViewCell {
    @IBOutlet weak var myImgView: UIImageView!
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? #colorLiteral(red: 0.9764705882, green: 0.4, blue: 0.4392156863, alpha: 1) : .white
            self.myImgView.alpha = isSelected ? 0.65 : 1.0
        }
    }
    
    func configure(data : String) {
       setImgWithKF(url: data, imgView: myImgView, defaultImg: #imageLiteral(resourceName: "aimg"))
    }
    
    
    
    override func awakeFromNib() {
        self.makeCornerRound(cornerRadius: self.frame.height/2)
    }
    

}
