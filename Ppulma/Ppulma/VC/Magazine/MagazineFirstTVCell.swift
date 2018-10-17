//
//  MagazineFirstTVCell.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class MagazineFirstTVCell: UITableViewCell {

    var imgArr = [#imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg")]
    var imgArr2 = [#imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg")]

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
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
            imgArr2 = [#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "bimg")]
            secondCollectionView.reloadData()
            collectionViewHeight.constant = secondCollectionView.collectionViewLayout.collectionViewContentSize.height
            delegate?.tap(selected: 0)
        } else {
            
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MagazineFirstTVCell: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            return 16
        } else {
            return 16
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
             return CGSize(width: 100, height: 100)
        } else {
             return CGSize(width: 170, height: 250)
        }
    }

}
