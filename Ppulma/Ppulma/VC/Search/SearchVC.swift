//
//  SearchVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 27..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UIGestureRecognizerDelegate {
    

    let originalArr = ["커플", "커플 아이템", "커플 잠옷", "커플 팔찌", "커플 마사지", "커플 반팔티", "커플 속옷", "커플 반지", "커플 맨투맨", "커플 케이스", "커플 신발"]
    var mainArr : [String] = []
    var keyboardDismissGesture: UITapGestureRecognizer?
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setBackBtn(color: ColorChip.shared().barbuttonColor)
        setKeyboardSetting()
        searchField.delegate = self
        self.searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
    }
}

extension SearchVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTVCell.reuseIdentifier) as! SearchTVCell
        cell.configure(data : mainArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let searchResultVC = mainStoryboard.instantiateViewController(withIdentifier:SearchResultVC.reuseIdentifier) as? SearchResultVC {
            searchResultVC.searchString = mainArr[indexPath.row]
            self.navigationController?.pushViewController(searchResultVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//키보드 대응
extension SearchVC{
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {

        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset.bottom = keyboardSize.height
        }
        
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset.bottom = 0
        
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


extension SearchVC : UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
       
        if textField.text == "" {
            mainArr = []
            backgroundView.image = #imageLiteral(resourceName: "searchImgView")
            tableView.reloadData()
            return
        }
        
        
        if let searchString_ = textField.text {
            mainArr = originalArr.filter({ (item) -> Bool in
                item.contains(searchString_)
            })
            backgroundView.image = #imageLiteral(resourceName: "whiteBackground")
            tableView.reloadData()
        }
        
    }
    
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
            let mainStoryboard = Storyboard.shared().mainStoryboard
            if let searchResultVC = mainStoryboard.instantiateViewController(withIdentifier:SearchResultVC.reuseIdentifier) as? SearchResultVC {
                searchResultVC.searchString = searchString_
                self.navigationController?.pushViewController(searchResultVC, animated: true)
            }
        }
        
        return true
    }
}



