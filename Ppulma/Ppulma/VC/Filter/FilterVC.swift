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
    @IBOutlet weak var titleLbl: UILabel!
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = navTitle
        mainImgView.image = mainImg
    }

   

}
