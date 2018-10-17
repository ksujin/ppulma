//
//  ViewController.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import BottomPopup

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showViewControllerTapped(_ sender: UIButton) {
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
        popupVC.height = 300
        popupVC.topCornerRadius = 10
        popupVC.presentDuration = 0.2
        popupVC.dismissDuration = 0.2
        popupVC.shouldDismissInteractivelty = true
        present(popupVC, animated: true, completion: nil)
    }


}

