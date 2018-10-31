//
//  SearchResultVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 27..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController, UIGestureRecognizerDelegate {
    
    var searchString = ""
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    var resultArr : [SearchVOResult] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var keyboardDismissGesture: UITapGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn(color: ColorChip.shared().barbuttonColor)
        setupCollectionView()
        setKeyboardSetting()
        getSearchResult(url: UrlPath.search.getURL(searchString))
        searchField.delegate = self
        searchField.text = searchString
        let cartItem = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "icCart"), target: self, action: #selector(SearchResultVC.cartAction(_:)))
        self.navigationItem.rightBarButtonItems = [cartItem]
        
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
            filterVC.navTitle = "필터"
            filterVC.mainImg = #imageLiteral(resourceName: "filterImgView")
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
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let detailVC = mainStoryboard.instantiateViewController(withIdentifier:DetailVC.reuseIdentifier) as? DetailVC {
            detailVC.productIdx = resultArr[indexPath.row].productIdx
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
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

//키보드 대응
extension SearchResultVC{
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            collectionView.contentInset.bottom = keyboardSize.height
        }
        
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        collectionView.contentInset.bottom = 0
        
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
        
    }
    
    //화면 바깥 터치했을때 키보드 없어지는 코드
    func adjustKeyboardDismissGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
                view.addGestureRecognizer(keyboardDismissGesture!)
            }
        } else {
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    
    @objc func tapBackground() {
        //내 텍필
        self.view.endEditing(true)
    }
}


extension SearchResultVC : UITextFieldDelegate {
    
    //키보드 엔터 버튼 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            simpleAlert(title: "오류", message: "검색어 입력")
            return false
        }
        
        if let myString = textField.text {
            let emptySpacesCount = myString.components(separatedBy: " ").count-1
            if emptySpacesCount == myString.count {
                simpleAlert(title: "오류", message: "검색어 입력")
                return false
            }
        }
        
        //있으면 리로드, 없으면 얼러트
        if let searchString_ = textField.text {
            //검색 통신
            getSearchResult(url: UrlPath.search.getURL(searchString_))
        }
        
        return true
    }
}

extension SearchResultVC {
    func getSearchResult(url : String){
        self.pleaseWait()
        SearchService.shareInstance.getSearchResult(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.clearAllNotice()
            switch result {
            case .networkSuccess(let searchResult):
                let searchResult = searchResult as! [SearchVOResult]
                self.resultArr = searchResult
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
