//
//  FilterVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 27..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    
    var mainImg = UIImage()
    var navTitle = ""
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var navLine: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = navTitle
        mainImgView.image = mainImg
        switch navTitle {
        case "할인정보 안내" :
            titleLbl.textColor = .white
            self.view.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)
            navLine.isHidden = true
            dismissBtn.setImage(#imageLiteral(resourceName: "icDismissWhite"), for: .normal)
        case "회원레벨 안내" :
            navLine.isHidden = true
        default :
            break
        }
       
    }

   

}
