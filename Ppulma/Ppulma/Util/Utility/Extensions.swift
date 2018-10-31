//
//  Extensions.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import Kingfisher

/*---------------------NSObject---------------------------*/
extension NSObject {
    static var reuseIdentifier:String {
        return String(describing:self)
    }
}

/*---------------------UIView---------------------------*/

extension UIView {
    func makeRounded(cornerRadius : CGFloat?){
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            self.layer.cornerRadius = self.layer.frame.height/2
        }
        self.layer.masksToBounds = true
    }
    
    func makeViewBorder(width : Double, color : UIColor){
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.cgColor
    }
    
    
    func makeShadow(myImage : UIImage, cornerRadius : CGFloat){
        let myImgView = UIImageView()
        self.clipsToBounds = false
        self.layer.applySketchShadow(alpha : 0.16, x : 0, y : 2, blur : 6, spread : 2)
        self.backgroundColor = UIColor.clear
        myImgView.frame = self.bounds
        myImgView.clipsToBounds = true
        myImgView.layer.cornerRadius = cornerRadius
        myImgView.image = myImage
        self.addSubview(myImgView)
    }
    
}

extension UIImageView {
    func setImgWithKF(url : String, defaultImg : UIImage){
        if let url = URL(string: url){
            self.kf.setImage(with: url)
        } else {
            self.image = defaultImg
        }
    }
}

extension UIViewController {
    func setImgWithKF(url : String, imgView : UIImageView, defaultImg : UIImage){
        if let url = URL(string: url){
            imgView.kf.setImage(with: url)
        } else {
            imgView.image = defaultImg
        }
    }
    
    //백버튼
    func setBackBtn(color : UIColor? = .white){
        let backBTN = UIBarButtonItem(image: UIImage(named: "icBack"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(self.pop))
        navigationItem.leftBarButtonItem = backBTN
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func simpleAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okTitle =  "확인"
        let okAction = UIAlertAction(title: okTitle,style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    func simpleAlertwithHandler(title: String, message: String, okHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okTitle = "확인"
        let cancelTitle = "취소"
        let okAction = UIAlertAction(title: okTitle,style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: cancelTitle,style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func networkSimpleAlert(){
        let title = "오류"
        let message = "네트워크 연결상태를 확인해주세요"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okTitle = "확인"
        let okAction = UIAlertAction(title: okTitle,style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func addChildView(containerView : UIView, asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    func removeChildView(containerView : UIView, asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
}

/*---------------------UICollectionViewCell---------------------------*/
extension UICollectionViewCell {
    func makeCornerRound(cornerRadius : CGFloat){
        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
    }
    
    
}

/*---------------------CALayer---------------------------*/
extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat = 4,
        spread: CGFloat = 0,
        shadowRadius_ : CGFloat? = 4
        )
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        //원래는 이거였음 shadowRadius = blur / 2.0
        shadowRadius = shadowRadius_ ?? blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

/*---------------------Int---------------------------*/
extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

/*---------------------UIBarButtonItem---------------------------*/

extension UIBarButtonItem {
    class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}

extension UITableViewCell {
    func setImgWithKF(url : String, imgView : UIImageView, defaultImg : UIImage){
        if let url = URL(string: url){
            imgView.kf.setImage(with: url)
        } else {
            imgView.image = defaultImg
        }
    }
    
}

/*---------------------UICollectionViewCell---------------------------*/
extension UICollectionViewCell {
    
    
    func setImgWithKF(url : String, imgView : UIImageView, defaultImg : UIImage){
        if let url = URL(string: url){
            imgView.kf.setImage(with: url)
        } else {
            imgView.image = defaultImg
        }
    }
    
}

//컨스트레인
extension UIView {
    
    func removeConstraints() {
        removeConstraints(constraints)
    }
    
    func deactivateAllConstraints() {
        NSLayoutConstraint.deactivate(getAllConstraints())
    }
    
    func getAllSubviews() -> [UIView] {
        return UIView.getAllSubviews(view: self)
    }
    
    func getAllConstraints() -> [NSLayoutConstraint] {
        
        var subviewsConstraints = getAllSubviews().flatMap { (view) -> [NSLayoutConstraint] in
            return view.constraints
        }
        
        if let superview = self.superview {
            subviewsConstraints += superview.constraints.flatMap{ (constraint) -> NSLayoutConstraint? in
                if let view = constraint.firstItem as? UIView {
                    if view == self {
                        return constraint
                    }
                }
                return nil
            }
        }
        
        return subviewsConstraints + constraints
    }
    
    class func getAllSubviews(view: UIView) -> [UIView] {
        return view.subviews.flatMap { subView -> [UIView] in
            return [subView] + getAllSubviews(view: subView)
        }
    }
}

