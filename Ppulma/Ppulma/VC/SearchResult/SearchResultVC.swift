//
//  SearchResultVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 27..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

struct SampleSearchResultStruct {
    let title : String
    let price : Int
    let image : UIImage
}

class SearchResultVC: UIViewController, UIGestureRecognizerDelegate {
    
    var searchString = ""
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    var resultArr : [SampleSearchResultStruct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn(color: ColorChip.shared().barbuttonColor)
        setupCollectionView()
        searchField.text = searchString
        
        let cartItem = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "icCart"), target: self, action: #selector(SearchResultVC.cartAction(_:)))
        self.navigationItem.rightBarButtonItems = [cartItem]
        
        let aItem = SampleSearchResultStruct(title: "팔찌", price: 1000, image: #imageLiteral(resourceName: "aimg"))
        let bItem = SampleSearchResultStruct(title: "목걸이", price: 1000, image: #imageLiteral(resourceName: "aimg"))
        let cItem = SampleSearchResultStruct(title: "목걸이", price: 1000, image: #imageLiteral(resourceName: "bimg"))
        resultArr.append(contentsOf: [aItem, bItem, cItem])
        
    }
    
    @objc func cartAction(_ sender : UIBarButtonItem){
        
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SearchResultVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultArr.count
    }
    
    //헤더 뷰
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SearchResultHeader.reuseIdentifier,
                                                                         for: indexPath) as! SearchResultHeader
        headerView.filterBtn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)

        
        return headerView
    }
    
    @objc func filterAction(){
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let filterVC = mainStoryboard.instantiateViewController(withIdentifier:FilterVC.reuseIdentifier) as? FilterVC {
            self.present(filterVC, animated: true, completion: nil)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: SearchResultCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCVCell.reuseIdentifier, for: indexPath) as? SearchResultCVCell{
            cell.configure(data : resultArr[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultVC: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 161, height: 220)
        
    }
    
}
