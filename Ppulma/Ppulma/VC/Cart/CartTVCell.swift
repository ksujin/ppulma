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
    @IBOutlet weak var goodsImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    var cancleHandler : ((_ row : Int)->Void)?
    var delegate : SelectRowDelegate?
    var checkDelegate : CheckDelegate?
    var won : Int = 1
    var count : Int = 0
    func configure(data : SampleCartStruct, row : Int){
        nameLbl.text = data.name
        priceLbl.text = "\(data.price)원"
        descLbl.text = data.desc
        stepper.value = Double(data.value)
        count = Int(stepper.value)
        won = data.price
        checkBtn.tag = row
        stepper.leftButton.tag = row
        stepper.rightButton.tag = row
        deleteBtn.tag = row
    }
    
    func selectedConfig(isSelected : Bool){
        checkBtn.isSelected = isSelected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        whiteView.fillColor = .white
        stepper.leftButton.addTarget(self, action: #selector(valueChaned(_:)), for: .touchUpInside)
        stepper.rightButton.addTarget(self, action: #selector(valueChaned(_:)), for: .touchUpInside)
        checkBtn.setImage(UIImage(named: "aimg"), for: .normal)
        checkBtn.setImage(
            UIImage(named: "bimg"), for: .selected)
        checkBtn.addTarget(self, action: #selector(checkAction(_:)), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        
    }
    
    //checkBtn 클릭
    @objc func deleteAction(_ sender : UIButton){
        cancleHandler!(sender.tag)
    }
    
    //checkBtn 클릭
    @objc func checkAction(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        //0보내지는일 없게 +1 해줌
        if sender.isSelected {
            //select
            checkDelegate?.check(selected: sender.tag+1)
        } else {
            //deselect
            checkDelegate?.check(selected: -(sender.tag+1))
        }
    }
    
    //stepper 클릭
    @objc func valueChaned(_ sender : UIButton){
        //selected에 바뀐 value 들어감
        delegate?.tap(row: sender.tag, selected: Int(stepper.value))
    }
}
