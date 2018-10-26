//
//  MainVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
struct SampleMainStruct {
    let idx : Int
    let img : UIImage
    let backgroundImg : UIImage
}


class MainVC: UIViewController {

    
    @IBOutlet weak var sOuterView: UIView!
    @IBOutlet weak var wOutherView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!

    @IBOutlet weak var alarmBtn: UIButton!
    @IBOutlet weak var alarmOrangeVie: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    var mainArr : [SampleMainStruct] = []
    
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
        setSampleData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 8))
        tableView.tableFooterView?.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        firstLbl.text = Int(sampleUser.saveMoney).withCommas()+"원"
        secondLbl.text = Int(sampleUser.point).withCommas()+"원"
        alarmOrangeVie.makeRounded(cornerRadius: nil)
        sOuterView.makeShadow(myImage: #imageLiteral(resourceName: "icS"), cornerRadius: sOuterView.frame.height/2)
        wOutherView.makeShadow(myImage: #imageLiteral(resourceName: "icP"), cornerRadius: wOutherView.frame.height/2)
    }
    
    @objc func getUserInfo(_ notification : Notification) {
       firstLbl.text = Int(sampleUser.point).withCommas()+"원"
       secondLbl.text = Int(sampleUser.saveMoney).withCommas()+"원"
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let searchVC = mainStoryboard.instantiateViewController(withIdentifier:SearchVC.reuseIdentifier) as? SearchVC {
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    func setSampleData(){
        let firstItem = SampleMainStruct(idx: 1, img: #imageLiteral(resourceName: "planLove"), backgroundImg: #imageLiteral(resourceName: "background"))
        let secondItem = SampleMainStruct(idx: 2, img: #imageLiteral(resourceName: "planAlone"), backgroundImg: #imageLiteral(resourceName: "background"))
        let thirdItem = SampleMainStruct(idx: 3, img: #imageLiteral(resourceName: "planPet"), backgroundImg: #imageLiteral(resourceName: "background"))
        let forthItem = SampleMainStruct(idx: 4, img: #imageLiteral(resourceName: "planHealing"), backgroundImg: #imageLiteral(resourceName: "background"))
        let fifthItem = SampleMainStruct(idx: 5, img: #imageLiteral(resourceName: "planSanta"), backgroundImg: #imageLiteral(resourceName: "background"))
        mainArr.append(contentsOf: [firstItem, secondItem, thirdItem, forthItem, fifthItem])
    }
}

extension MainVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTVCell.reuseIdentifier) as! MainTVCell
        let imageArr = mainArr.map { (item) in
            item.img
        }
        cell.configure(data : imageArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let magazineVC = mainStoryboard.instantiateViewController(withIdentifier:MagazineVC.reuseIdentifier) as? MagazineVC {
            magazineVC.topImg = mainArr[indexPath.row].backgroundImg
            self.navigationController?.pushViewController(magazineVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
