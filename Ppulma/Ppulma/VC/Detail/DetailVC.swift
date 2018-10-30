//
//  DetailVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 27..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var salePriceLbl: UILabel!
    @IBOutlet weak var detailImgView: UIImageView!
    var productIdx = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn(color: ColorChip.shared().barbuttonColor)
        let cartItem = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "icCart"), target: self, action: #selector(SearchResultVC.cartAction(_:)))
        self.navigationItem.rightBarButtonItems = [cartItem]
        if productIdx != "" {
            getDetailInfo(url : UrlPath.product.getURL(productIdx))
        }
    }

    @IBAction func goSaleAction(_ sender: Any) {
    }
    
    
    @IBAction func addCartAction(_ sender: Any) {
        let params : [String : Any] = ["product_idx" : productIdx,
                                       "count" : 1]
        addToCart(url: UrlPath.cart.getURL(), params: params)
    }
    
}

//통신
extension DetailVC {
    func getDetailInfo(url : String){
        self.pleaseWait()
        ProductDetailService.shareInstance.getDetailData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.clearAllNotice()
            switch result {
            case .networkSuccess(let productData):
                let productData = productData as! [ProductDetailVOResult]
                let data = productData.first!
                self.titleLbl.text = data.name
                self.priceLbl.text = data.price.withCommas()+"원"
                self.titleImgView.setImgWithKF(url: data.imgURL, defaultImg: #imageLiteral(resourceName: "aimg"))
                self.detailImgView.setImgWithKF(url: data.detailURL, defaultImg: #imageLiteral(resourceName: "aimg"))
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func addToCart(url : String, params : [String : Any]){
        self.pleaseWait()
       
        AddCartService.shareInstance.addCart(url: url, params : params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.clearAllNotice()
            switch result {
            case .networkSuccess(_):
                self.noticeSuccess("장바구니 담기 성공!", autoClear: true, autoClearTime: 1)
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    
    
}
