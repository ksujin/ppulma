//
//  MagazineFirstTVCell.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import Dropper

class MagazineFirstTVCell: UITableViewCell {

    var imgArr = [#imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg")]
    var imgArr2 : [UIImage] = [] {
        didSet {
            if let imgHandler_ = imgHandler {
               imgHandler_()
            }
        }
    }
    let dropper = Dropper(width: 75, height: 200)
    var imgHandler : (()->Void)?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filterLblBtn: UIButton!
    @IBAction func filterAction(_ sender: Any) {
        //dropper
        if dropper.status == .hidden {
            dropper.items = ["인기순", "낮은가격순"]
            dropper.theme = Dropper.Themes.white
            dropper.border.color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            dropper.cellTextFont = UIFont(name: NanumSquareOTF.NanumSquareOTFR.rawValue, size: 13)!
            dropper.cellColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
            dropper.cornerRadius = 3
            dropper.showWithAnimation(0.15, options: .center, position: .bottom, button: filterLblBtn)
            self.addSubview(dropper)
        } else {
            dropper.hideWithAnimation(0.1)
        }
    }
    var delegate : SelectDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.secondCollectionView.delegate = self
        self.secondCollectionView.dataSource = self
        
        //처음에도 간격 맞게 해줌
        self.layoutIfNeeded()
        collectionViewHeight.constant = secondCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        filterLblBtn.addTarget(self, action: #selector(filterAction(_:)), for: .touchUpInside)
       
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MagazineFirstTVCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return imgArr.count
        } else {
            return imgArr2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            if let cell: MagazineFirstCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineFirstCVCell.reuseIdentifier, for: indexPath) as? MagazineFirstCVCell{
                cell.configure(data: imgArr[indexPath.row])
                return cell
            }
            return UICollectionViewCell()
        } else {
            
            if let cell: MagazineSecondCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineSecondCVCell.reuseIdentifier, for: indexPath) as? MagazineSecondCVCell{
                cell.configure(data: imgArr2[indexPath.row])
                return cell
            }
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            delegate?.tap(section: 0, selected: 0)
        } else {
             delegate?.tap(section: 1, selected: 0)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MagazineFirstTVCell: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            return 10
        } else {
            return 20
        }
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            return 0
        } else {
            return 0
        }
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
             return CGSize(width: 72, height: 72)
        } else {
             return CGSize(width: 110, height: 147)
        }
    }

}

