//
//  MagazineVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import Dropper

private let IMAGE_HEIGHT:CGFloat = 433
private let NAVBAR_COLORCHANGE_POINT:CGFloat = IMAGE_HEIGHT - CGFloat(kNavBarBottom * 2)
class MagazineVC: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var tableView : UITableView!
    var topImg = UIImage()
    lazy var topView:UIImageView = {
        let imgView = UIImageView(image: topImg)
        imgView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: IMAGE_HEIGHT)
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavView()
    }
    func setupTableView(){
        tableView.contentInset = UIEdgeInsetsMake(-CGFloat(kNavBarBottom), 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = topView
        tableView.tableFooterView = UIView(frame: .zero)
    } //setupTableView
    
    func setupNavView(){
        //왼쪽 백버튼 아이템 설정
        setBackBtn(color: .white)
        self.navigationItem.title = ""
        //네비게이션바 컬러
        navBarBarTintColor = .white
        navBarBackgroundAlpha = 0
        //네비게이션 바 안의 아이템 컬러
        navBarTintColor = .white
    }
}

extension MagazineVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MagazineFirstTVCell.reuseIdentifier) as! MagazineFirstTVCell
        cell.delegate = self
        cell.dropper.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MagazineVC : SelectDelegate {
    func tap(selected: Int?) {
        let cell = tableView.cellForRow(at: IndexPath(row : 0, section : 0)) as! MagazineFirstTVCell
        cell.imgArr2 = [#imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "bimg"), #imageLiteral(resourceName: "bimg")]
        cell.secondCollectionView.reloadData()
        cell.collectionViewHeight.constant = cell.secondCollectionView.collectionViewLayout.collectionViewContentSize.height
        tableView.reloadData()
    }
}

// MARK: - 스크롤 할 때 네비게이션 색깔
extension MagazineVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        //정해진 포인트보다 아래로 스크롤
        if (offsetY > NAVBAR_COLORCHANGE_POINT){
            navBarTintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
            navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
            let alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / CGFloat(kNavBarBottom)
            navBarBackgroundAlpha = alpha
            navBarTintColor = UIColor.black.withAlphaComponent(alpha)
            navBarTitleColor = UIColor.black.withAlphaComponent(alpha)
            statusBarStyle = .default
        }
            //정해진 포인트 보다 위로 스크롤
        else {
            navBarTintColor = .white
            navigationItem.leftBarButtonItem?.tintColor = .white
            navBarBackgroundAlpha = 0
            navBarTitleColor = .white
            statusBarStyle = .lightContent
        }
    }
}

extension MagazineVC: DropperDelegate {
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        let cell = tableView.cellForRow(at: IndexPath(row : 0, section : 0)) as! MagazineFirstTVCell
        cell.filterLblBtn.setTitle(contents, for: .normal)
        if contents == "인기순" {
            cell.imgArr2 = [#imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg")]
        } else {
            cell.imgArr2 = [#imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "bimg")]
        }
        cell.secondCollectionView.reloadData()
        cell.collectionViewHeight.constant = cell.secondCollectionView.collectionViewLayout.collectionViewContentSize.height
        tableView.reloadData()
    }
}
