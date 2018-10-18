//
//  MainVC.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit



class MainVC: UIViewController {

    
    @IBOutlet weak var sOuterView: UIView!
    @IBOutlet weak var wOutherView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var alarmBtn: UIButton!
    @IBOutlet weak var alarmOrangeVie: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    let imgArr = [#imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg"), #imageLiteral(resourceName: "aimg")]
    
  
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 8))
        tableView.tableFooterView?.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        firstLbl.text = "13000원"
        secondLbl.text = "87000원"
        firstLbl.textColor = ColorChip.shared().mainPurple
        secondLbl.textColor = ColorChip.shared().mainOrange
        sOuterView.makeShadow(myImage: #imageLiteral(resourceName: "aimg"), cornerRadius: sOuterView.frame.height/2)
        wOutherView.makeShadow(myImage: #imageLiteral(resourceName: "aimg"), cornerRadius: wOutherView.frame.height/2)
    }
    
    
}

extension MainVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTVCell.reuseIdentifier) as! MainTVCell
        cell.configure(data : imgArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = Storyboard.shared().mainStoryboard
        if let magazineVC = mainStoryboard.instantiateViewController(withIdentifier:MagazineVC.reuseIdentifier) as? MagazineVC {
            self.navigationController?.pushViewController(magazineVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
