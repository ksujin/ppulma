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
    func configure(data : UIImage) {
       myImgView.image = data
    }
    
    
    
    
    override func awakeFromNib() {
        self.makeCornerRound(cornerRadius: self.frame.height/2)
    }
}
