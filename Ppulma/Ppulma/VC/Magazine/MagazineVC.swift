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
    var magazineIdx = ""
    var categoryIdx = ""
    var isOrderByPopular = true
    
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
        let cell = tableView.cellForRow(at: IndexPath(row : 0, section : 0)) as! MagazineFirstTVCell
        getMagazineInfo(url : UrlPath.category.getURL(magazineIdx))
        cell.imgHandler = reloadTVForCV
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
    
    func reloadTVForCV(){
        let cell = tableView.cellForRow(at: IndexPath(row : 0, section : 0)) as! MagazineFirstTVCell
        cell.secondCollectionView.reloadData()
        cell.collectionViewHeight.constant = cell.secondCollectionView.collectionViewLayout.collectionViewContentSize.height
        tableView.reloadData()
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
    func tap(section: Int, selected: Any) {
        if section == 0 {
            categoryIdx = selected as! String
            if isOrderByPopular {
                getSemiInfo(url: UrlPath.semiCategory.getURL(categoryIdx))
            } else {
                getSemiInfo(url: UrlPath.semiCategoryOrderByPrice.getURL(categoryIdx))
            }
        } else {
            let mainStoryboard = Storyboard.shared().mainStoryboard
            if let detailVC = mainStoryboard.instantiateViewController(withIdentifier:DetailVC.reuseIdentifier) as? DetailVC {
                
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
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
            isOrderByPopular = true
            getSemiInfo(url: UrlPath.semiCategory.getURL(categoryIdx))
        } else {
            isOrderByPopular = false
            getSemiInfo(url: UrlPath.semiCategoryOrderByPrice.getURL(categoryIdx))
        }
    }
}

//통신
extension MagazineVC {
    func getMagazineInfo(url : String){
        self.pleaseWait()
        MagazineService.shareInstance.getMagazineData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.clearAllNotice()
            switch result {
            case .networkSuccess(let magazineData):
                let magazineData = magazineData as! [CategoryVOSemiResult]
                let cell = self.tableView.cellForRow(at: IndexPath(row : 0, section : 0)) as! MagazineFirstTVCell
                cell.firstDataArr = magazineData
                self.categoryIdx = magazineData[0].semiCategoryIdx
                self.getSemiInfo(url: UrlPath.semiCategory.getURL(magazineData[0].semiCategoryIdx))
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func getSemiInfo(url : String){
        self.pleaseWait()
        SemiCategoryService.shareInstance.getSemiCategoryData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.clearAllNotice()
            switch result {
            case .networkSuccess(let semiData):
                let semiData = semiData as! [SemiCategoryVOResult]
                let cell = self.tableView.cellForRow(at: IndexPath(row : 0, section : 0)) as! MagazineFirstTVCell
                cell.secondDataArr = semiData
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}

