//
//  CartTVCell.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 18..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class CartTVCell: UITableViewCell {

    @IBOutlet weak var whiteView: RoundShadowView!
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var goodsOuterView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    var deleteHandler : ((_ idx : String)->Void)?
    var stepperHandler : ((_ idx: String, _ count : Int)->Void)?
    var checkHandler : ((_ idx: String, _ checked : Bool)->Void)?
    var won : Int = 1
    var count : Int = 0
    var myImgView = UIImageView()
    
    func configure(data : CartVOResult, row : Int){
        myImgView.setImgWithKF(url: data.productImg, defaultImg: #imageLiteral(resourceName: "aimg"))
        nameLbl.text = data.productName
        priceLbl.text = data.productPrice.withCommas()+"원"
        descLbl.text = ""
        stepper.value = Double(data.productCount)
        count = Int(stepper.value)
        won = data.productPrice
        if data.check {
            checkBtn.setImage(#imageLiteral(resourceName: "icCheckDone"), for: .normal)
            checkBtn.tag = 1
        } else {
            checkBtn.setImage(#imageLiteral(resourceName: "icCheckBox"), for: .normal)
            checkBtn.tag = 0
        }
       
        stepper.leftButton.accessibilityIdentifier = data.cartIdx
        stepper.rightButton.accessibilityIdentifier = data.cartIdx
        deleteBtn.accessibilityIdentifier = data.cartIdx
        checkBtn.accessibilityIdentifier = data.cartIdx
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        whiteView.fillColor = .white
        stepper.leftButton.addTarget(self, action: #selector(valueChaned(_:)), for: .touchUpInside)
        stepper.rightButton.addTarget(self, action: #selector(valueChaned(_:)), for: .touchUpInside)
        checkBtn.addTarget(self, action: #selector(checkAction(_:)), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        //shadow
        goodsOuterView.clipsToBounds = false
        goodsOuterView.layer.applySketchShadow(alpha : 0.16, x : 0, y : 2, blur : 6, spread : 2)
        goodsOuterView.backgroundColor = UIColor.clear
        myImgView.frame = goodsOuterView.bounds
        myImgView.clipsToBounds = true
        myImgView.layer.cornerRadius = 7
        goodsOuterView.addSubview(myImgView)
    }
    

    @objc func deleteAction(_ sender : UIButton){
        deleteHandler!(sender.accessibilityIdentifier!)
    }
    
    @objc func checkAction(_ sender : UIButton){
        //반대로 바꿔줘야함
        let checked = sender.tag == 1 ? false : true
        checkHandler!(sender.accessibilityIdentifier!, checked)
    }
    
    //stepper 클릭
    @objc func valueChaned(_ sender : UIButton){
        stepperHandler!(sender.accessibilityIdentifier!, Int(stepper.value))
    }
}
