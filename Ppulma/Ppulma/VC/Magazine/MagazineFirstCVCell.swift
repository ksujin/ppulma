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
    @IBOutlet weak var titleLbl: UILabel!
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? #colorLiteral(red: 0.9803921569, green: 0.5764705882, blue: 0.5019607843, alpha: 1) : UIColor.red
            self.myImgView.alpha = isSelected ? 0.65 : 1.0
        }
    }
    
    func configure(data : UIImage) {
       myImgView.image = data
    }
    
    
    
    override func awakeFromNib() {
        self.makeCornerRound(cornerRadius: self.frame.height/2)
    }
    

}
