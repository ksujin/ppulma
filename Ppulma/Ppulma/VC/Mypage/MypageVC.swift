//
//  MypageVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import SnapKit

class MypageVC: UIViewController {
    
    @IBOutlet weak var savedLbl: UILabel!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomFirstView: UIView!
    @IBOutlet weak var bottomSecondView: UIView!

    var imgUrlArr : [String] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecentInfo(url: UrlPath.purchase.getURL())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getUserInfo(_:)), name: NSNotification.Name("GetUserValue"), object: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        setUserInfo()
        setUpLayout()
    }
    
    func setUpLayout(){
        whiteView.makeRounded(cornerRadius: nil)
        yellowView.makeRounded(cornerRadius: nil)
        bottomFirstView.makeViewBorder(width: 0.5, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
         bottomSecondView.makeViewBorder(width: 0.5, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    
    func setUserInfo(){
        savedLbl.text = Int(sampleUser.payMoney).withCommas()+"원"
        let maxMoney : Double = 500000
        let payMoney = sampleUser.payMoney
        yellowView.deactivateAllConstraints()
        if payMoney == 0.0 {
            yellowView.snp.makeConstraints { (make) in
                make.leading.top.bottom.equalToSuperview()
                make.width.equalTo(0)
            }
            return
        }
        
        if payMoney >= maxMoney {
            yellowView.snp.makeConstraints { (make) in
                make.leading.top.bottom.equalToSuperview()
                make.width.equalToSuperview()
            }
            return
        }
        
        let ratio =  maxMoney/payMoney
        
        yellowView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(ratio)
        }
    }
    
    @objc func getUserInfo(_ notification : Notification) {
        setUserInfo()
    }
    
    @IBAction func showClassBenefitAction(_ sender: Any) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let filterVC = mainStoryboard.instantiateViewController(withIdentifier:FilterVC.reuseIdentifier) as? FilterVC {
            filterVC.navTitle = "회원레벨 안내"
            filterVC.mainImg = #imageLiteral(resourceName: "levelinfo")
            self.present(filterVC, animated: true, completion: nil)
        }
    }
    
}

extension MypageVC :  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrlArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MypageCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageCVCell.reuseIdentifier, for: indexPath) as? MypageCVCell {
            cell.configure(data: imgUrlArr[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MypageVC: UICollectionViewDelegateFlowLayout {
   
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 72)
    }
    
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

//통신
extension MypageVC {
    func getRecentInfo(url : String){
        self.pleaseWait()
        RecentItemService.shareInstance.getRecentList(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.clearAllNotice()
            switch result {
            case .networkSuccess(let productData):
                let productData = productData as! [RecentItemVOResult]
                self.imgUrlArr = productData.map({ (item) in
                    item.imgURL[0]
                })
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}

