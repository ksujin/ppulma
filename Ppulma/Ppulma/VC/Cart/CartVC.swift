//
//  CartVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 18..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

//TODO:- 1. 검색  2. 체크 결제
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
    var saveMoney : Double
    var payMoney : Double
}


var sampleUser = SampleUserStruct(name: "sujin", point: 100000, saveMoney : 0, payMoney : 0)

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
    
    var cartListArr : [CartVOResult] = [] {
        didSet {
            selectAllLbl.text = "전체 선택 (총 \(cartListArr.count)개)"
            selectAllLbl.sizeToFit()
            tableView.reloadData()
            self.setPriceLbl()
        }
    }
    var willDecrease_ : Double = 0
    var afterDecrease_ : Double = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartList(url: UrlPath.cart.getURL())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        purpleTopView.layoutSubviews()
        getCartList(url: UrlPath.cart.getURL())

        selectAllBtn.setImage(UIImage(named: "icCheckBox"), for: .normal)
        selectAllBtn.setImage(
            UIImage(named: "icCheckDone"), for: .selected)
        selectAllBtn.addTarget(self, action: #selector(selectAllAction(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setPriceLbl()
    }
    

    @IBAction func deleteAction(_ sender: Any) {
        let rowNum = tableView.numberOfRows(inSection: 0)
        for row in 0..<rowNum{
            //select되었는지 아닌지 체크
            if cartListArr[row].check {
                let idx = cartListArr[row].cartIdx
                deleteFromCart(url: UrlPath.cart.getURL(idx))
            }
        }
    }
    
    @IBAction func payAction(_ sender: Any) {
        //TODO:- 체크 되어 있는것 전체 삭제
        let rowNum = tableView.numberOfRows(inSection: 0)
        var idxArr : [String] = []
        for row in 0..<rowNum{
            //select되었는지 아닌지 체크
            if cartListArr[row].check {
                idxArr.append(cartListArr[row].cartIdx)
            }
        }
        let params : [String : Any] = ["cart_idx" : idxArr]
        deleteFromCart(url: UrlPath.cart.getURL(), params: params)
        //원래 통신 완료후
        sampleUser.point -= willDecrease_
        sampleUser.saveMoney += willDecrease_
        sampleUser.payMoney += afterDecrease_
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
    }
    
    func selectAllRows(selected : Bool) {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let selectedCart = cartListArr[row]
                updateCheck(idx: selectedCart.cartIdx, checked: selected)
            }
        }
    }
}

//테이블뷰 delegate, datasource
extension CartVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTVCell.reuseIdentifier) as! CartTVCell
        cell.configure(data: cartListArr[indexPath.row], row : indexPath.row)
        cell.stepperHandler = updateStepper
        cell.deleteHandler = deleteCart
        cell.checkHandler = updateCheck
        return cell
    }
}

//closure
extension CartVC{
    
    func updateStepper(idx: String, count: Int){
        let params : [String : Any] = ["product_count" : count]
        updateFromCart(url: UrlPath.cart.getURL(idx), params: params)
        setPriceLbl()
    }
    
    func deleteCart(idx: String){
        deleteFromCart(url: UrlPath.cart.getURL(idx))
        setPriceLbl()
    }

    func updateCheck(idx: String, checked: Bool){
        let params : [String : Any] = ["check" : checked]
        updateFromCart(url: UrlPath.cart.getURL(idx), params: params)
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
        afterDecrease_ = Double(totalPrice)-(willDecrease)
        
        salePercentLbl.text = salePercent.percentString
        decreasePointLbl.text = Int(willDecrease).withCommas()+"원"
        afterDecreaseLbl.text = Int(afterDecrease_).withCommas()+"원"
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
            if cartListArr[row].check {
                selectedCount += 1
                let tempItem = tempStruct(price: cartListArr[row].productPrice, count: Int(cartListArr[row].productCount))
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
        
        if selectedCount == cartListArr.count {
            selectAllBtn.isSelected = true
        } else {
            selectAllBtn.isSelected = false
        }
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

//통신
extension CartVC {
    func getCartList(url : String){
        self.pleaseWait()
        GetCartListService.shareInstance.getCartList(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.clearAllNotice()
            switch result {
            case .networkSuccess(let cartList):
                let cartList = cartList as! [CartVOResult]
                self.cartListArr = cartList
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func deleteFromCart(url : String, params : [String : Any] = [:]){
        self.pleaseWait()

        AddCartService.shareInstance.deleteCart(url: url, params : params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.clearAllNotice()
            switch result {
            case .networkSuccess(_):
                self.getCartList(url: UrlPath.cart.getURL())
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func updateFromCart(url : String, params : [String : Any]){
        self.pleaseWait()
        AddCartService.shareInstance.updateCart(url: url,params : params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.clearAllNotice()
            switch result {
            case .networkSuccess(_):
                self.getCartList(url: UrlPath.cart.getURL())
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
