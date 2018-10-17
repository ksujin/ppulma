//
//  CartVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 18..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

struct SampleCartStruct {
    let name : String
    let value : Int
    let price : Int
}

class CartVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var selectAllLbl: UILabel!
    
    var sampleArr : [SampleCartStruct] = []
    
    var totalPrice = 0 {
        didSet {
            tempLbl.text = totalPrice.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let a = SampleCartStruct(name: "할로윈모자", value: 1, price: 1000)
        let b = SampleCartStruct(name: "호박사탕", value: 2, price: 2000)
        let c = SampleCartStruct(name: "분장", value: 3, price: 3000)
        let d = SampleCartStruct(name: "술", value: 1, price: 4000)
        sampleArr.append(contentsOf: [a,b,c,d])
        totalPrice = sampleArr.map({ (item) in
            item.price*item.value
        }).reduce(0, +)
        selectAllLbl.text = "전체선택 \(sampleArr.count)개"
        selectAllLbl.sizeToFit()
        selectAllBtn.setImage(UIImage(named: "aimg"), for: .normal)
        selectAllBtn.setImage(
            UIImage(named: "bimg"), for: .selected)
        selectAllBtn.addTarget(self, action: #selector(selectAllAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        var deleteArr : [SampleCartStruct] = []
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                let cell = tableView.cellForRow(at: indexPath) as! CartTVCell
                if cell.checkBtn.isSelected {
                   deleteArr.append(sampleArr[indexPath.row])
                }
            }
        }
        print(deleteArr)
    }
    
    @objc func selectAllAction(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectAllRows(selected: true)
            tempLbl.text = sampleArr.count.description
        } else {
            selectAllRows(selected: false)
            tempLbl.text = "0"
        }
    }
    
    func selectAllRows(selected : Bool) {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                let cell = tableView.cellForRow(at: indexPath) as! CartTVCell
                cell.checkBtn.isSelected = selected
                
            }
        }
    }
}


extension CartVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTVCell.reuseIdentifier) as! CartTVCell
        cell.configure(data: sampleArr[indexPath.row])
        cell.delegate = self
        cell.checkDelegate = self
        return cell
    }
}

extension CartVC : SelectDelegate, CheckDelegate{
    //stepper클릭시 가격 담겨옴
    func tap(selected: Int?) {
        //tap할때마다 통신 성공하면 개수 label 도 바꾸고 totalPrice도 바꿔줌
        totalPrice += selected!
    }
    
    //check 할때마다 부르는 함수. 전체 체크된게 몇개인지 확인
    func check(selected: Int?) {
        var totalCheckCount = 0
            for row in 0..<tableView.numberOfRows(inSection: 0) {
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.cellForRow(at: indexPath) as! CartTVCell
                if cell.checkBtn.isSelected {
                    totalCheckCount += 1
                }
            }
        tempLbl.text = totalCheckCount.description
    }
}
