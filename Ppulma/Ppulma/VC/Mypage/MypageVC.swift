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
    
    
    
    let imageArr = [#imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "bimg")]
    
    
    //hide Navigation Bar only on first page
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        savedLbl.text = Int(sampleUser.saveMoney).withCommas()+"원"
        let maxMoney : Double = 500000
        let saveMoney = sampleUser.saveMoney
        print(saveMoney)
        if saveMoney == 0.0 {
            yellowView.snp.makeConstraints { (make) in
                make.width.equalTo(0)
            }
            return
        }
        
        let ratio =  maxMoney/saveMoney
        
        yellowView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().dividedBy(ratio).offset(10)
        }
    }
    
    @objc func getUserInfo(_ notification : Notification) {
        setUserInfo()
    }
    
    @IBAction func showClassBenefitAction(_ sender: Any) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let benefitInfoVC = mainStoryboard.instantiateViewController(withIdentifier:BenefitInfoVC.reuseIdentifier) as? BenefitInfoVC {
            // benefitInfoVC.entryPoint = 1
            self.navigationController?.pushViewController(benefitInfoVC, animated: true)
        }
    }
    
}

extension MypageVC :  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: MypageCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageCVCell.reuseIdentifier, for: indexPath) as? MypageCVCell {
            cell.configure(data: imageArr[indexPath.row])
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

