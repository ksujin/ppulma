//
//  MainTVCell.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MainTVCell: UITableViewCell {
    
    @IBOutlet weak var myImgView: UIImageView!
    
    func configure(data : UIImage){
        myImgView.image = data
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        myImgView.makeRounded(cornerRadius: 10)
        myImgView.makeViewBorder(width: 0.3, color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        // Initialization code
    }

   
}
