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
    var value : Int
    let price : Int
    let desc : String
    let img : UIImage
}

struct SampleUserStruct {
    let name : String
    var point : Double
}


var sampleUser = SampleUserStruct(name: "sujin", point: 13000)

enum SalePercent : Double {
    case zero = 0.0
    case five = 0.05
    case ten = 0.1
    case fifteen = 0.15
    
    var percentString : String {
        switch self {
        case .zero:
            return "0%"
        case .five:
            return "5%"
        case .ten:
            return "10%"
        case .fifteen:
            return "15%"
        }
    }
}


class CartVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var purpleTopView: RoundShadowView!
    //첫 통신에서 유저 포인트 전역변수로 박아놓고, 결제할때 접근해서 차감
    @IBOutlet weak var salePercentLbl : UILabel!
    @IBOutlet weak var decreasePointLbl: UILabel!
    @IBOutlet weak var afterDecreaseLbl: UILabel!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var selectAllLbl: UILabel!
    
    var sampleArr : [SampleCartStruct] = [] {
        didSet {
            selectAllLbl.text = "전체선택 \(sampleArr.count)개"
        }
    }
    var isSelectedArr : [Bool] = []
    var willDecrease_ : Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        purpleTopView.layoutSubviews()
       // purpleTopView.makeRounded(cornerRadius: 7)
        let a = SampleCartStruct(name: "커플 머그컵", value: 1, price: 1000, desc: "냥이 I BLUE&PINK", img: #imageLiteral(resourceName: "aimg"))
        let b = SampleCartStruct(name: "커플 휴대폰 케이스", value: 2, price: 2000, desc: "일러스트1 I BLUE&PINK", img: #imageLiteral(resourceName: "bimg"))
        let c = SampleCartStruct(name: "커플 카시오 시계", value: 3, price: 3000, desc: "WDFFS21 I 남성&여성", img: #imageLiteral(resourceName: "bimg"))
        let d = SampleCartStruct(name: "커플 수면 잠옷", value: 1, price: 4000, desc: "여름여름해 I 남성&여성", img: #imageLiteral(resourceName: "aimg"))
        let e = SampleCartStruct(name: "칸쵸", value: 1, price: 4000, desc: "여름여름해 I 남성&여성", img: #imageLiteral(resourceName: "aimg"))
        let f = SampleCartStruct(name: "볶음우동", value: 1, price: 4000, desc: "여름여름해 I 남성&여성", img: #imageLiteral(resourceName: "bimg"))
        sampleArr.append(contentsOf: [a,b,c,d,e,f])
    
        selectAllLbl.text = "전체선택 \(sampleArr.count)개"
        selectAllLbl.sizeToFit()
        selectAllBtn.setImage(UIImage(named: "icCheckBox"), for: .normal)
        selectAllBtn.setImage(
            UIImage(named: "bimg"), for: .selected)
        selectAllBtn.addTarget(self, action: #selector(selectAllAction(_:)), for: .touchUpInside)
        
        //처음에 전체 선택
        selectAllBtn.isSelected = true
        sampleArr.forEach { (_) in
            isSelectedArr.append(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setPriceLbl()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        var deleteArr : [SampleCartStruct] = []
        for section in 0..<tableView.numberOfSections {
            let rowNum = tableView.numberOfRows(inSection: section)
            for row in 0..<rowNum{
                if isSelectedArr[row] {
                    deleteArr.append(sampleArr[row])
                }
            }
        }
         self.tableView.reloadData()
        //통신
        print(deleteArr)
        //통신 완료 후
        sampleArr = deleteArr
        isSelectedArr = []
        sampleArr.forEach { (_) in
            isSelectedArr.append(false)
        }
        tableView.reloadData()
    }
    
    @IBAction func payAction(_ sender: Any) {
        //통신 완료후
        sampleUser.point -= willDecrease_
        NotificationCenter.default.post(name: NSNotification.Name("GetUserValue"), object: nil, userInfo: nil)
        setPriceLbl()
    }
    
    @objc func selectAllAction(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectAllRows(selected: true)
        } else {
            selectAllRows(selected: false)
        }
        setPriceLbl()
    }
    
    func selectAllRows(selected : Bool) {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                isSelectedArr[row] = selected
                tableView.reloadData()
            }
        }
    }
}

//테이블뷰 delegate, datasource
extension CartVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTVCell.reuseIdentifier) as! CartTVCell
        cell.configure(data: sampleArr[indexPath.row], row : indexPath.row)
        cell.cancleHandler = { (row) in
            self.sampleArr.remove(at: row)
            self.isSelectedArr.remove(at: row)
            self.tableView.reloadData()
        }
        if isSelectedArr.count > 0 {
           cell.selectedConfig(isSelected : isSelectedArr[indexPath.row])
        }
        
        cell.delegate = self
        cell.checkDelegate = self
        return cell
    }
}

//select Delegate
extension CartVC : SelectRowDelegate, CheckDelegate{
    //1. stepper클릭시
    func tap(row: Int, selected: Int) {
        //selected 에 stepper value 담겨져있음. 모델 변경
        sampleArr[row].value = selected
        setPriceLbl()
    }
    
    //2. check 버튼 클릭시
    func check(selected: Int?) {
        //deselect 이면 -, select이면 +
        if selected! > 0 {
            isSelectedArr[selected!-1] = true
        } else {
            isSelectedArr[(-(selected!)-1)] = false
        }
        //tap할때마다 통신 성공하면 개수 label 도 바꾸고 totalPrice도 바꿔줌
        setPriceLbl()
    }
}

//가격 구하고 lbl 세팅하는 함수
extension CartVC {
    
    func setPriceLbl(){
        let currentTotal = getSelectedTotalPrice()
        let totalPrice = currentTotal.price
        let salePercent = currentTotal.salePercent
 
        //유저가 들고 있는 포인트보다 더 커지면 안됨
        var willDecrease = Double(totalPrice)*salePercent.rawValue
        if willDecrease > sampleUser.point {
            willDecrease = sampleUser.point
        }
        willDecrease_ = willDecrease
        let afterDecrease = Double(totalPrice)-(willDecrease)
        
        salePercentLbl.text = salePercent.percentString
        decreasePointLbl.text = Int(willDecrease).withCommas()+"원"
        afterDecreaseLbl.text = Int(afterDecrease).withCommas()+"원"
        afterDecreaseLbl.sizeToFit()
    }
    
    func getSelectedTotalPrice() -> (price : Int, salePercent : SalePercent) {
        struct tempStruct {
            let price : Int
            let count : Int
        }
        var selectedItem : [tempStruct] = []
        var selectedCount = 0
        //선택된 아이템들 고름
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            if isSelectedArr[row] {
                
                selectedCount += 1
                let tempItem = tempStruct(price: sampleArr[row].price, count: Int(sampleArr[row].value))
                selectedItem.append(tempItem)
            }
        }
        let price = selectedItem.map({ (item) in
            item.price*item.count
        }).reduce(0, +)
        /*
         2개 품목: 5%
         3개 품목: 10%
         5개 품목 이상: 15%
         */
        var salePercent : SalePercent = .zero
        if selectedCount >= 5 {
            salePercent = .fifteen
        } else if selectedCount >= 3 {
            salePercent = .ten
        } else if selectedCount >= 2 {
            salePercent = .five
        }
        return (price, salePercent)
    }
}
