//
//  CartTVCell.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 18..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class CartTVCell: UITableViewCell {

    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var goodsImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var delegate : SelectDelegate?
    var checkDelegate : CheckDelegate?
    var won : Int = 1
    var count : Int = 0
    func configure(data : SampleCartStruct){
        nameLbl.text = data.name
        priceLbl.text = "\(data.price)원"
        stepper.value = Double(data.value)
        count = Int(stepper.value)
        won = data.price
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.leftButton.addTarget(self, action: #selector(valueChaned(_:)), for: .touchUpInside)
        stepper.rightButton.addTarget(self, action: #selector(valueChaned(_:)), for: .touchUpInside)
        checkBtn.setImage(UIImage(named: "aimg"), for: .normal)
        checkBtn.setImage(
            UIImage(named: "bimg"), for: .selected)
        checkBtn.addTarget(self, action: #selector(checkAction(_:)), for: .touchUpInside)
    }
    
    @objc func checkAction(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        checkDelegate?.check(selected: 0)
    }
    
    @objc func valueChaned(_ sender : UIButton){
        var changedVal = won
        if sender == stepper.leftButton {
            if count == 0 {return}
            count -=  1
            changedVal *= -1
        } else {
            count += 1
        }
        delegate?.tap(selected: changedVal)
    }
}
