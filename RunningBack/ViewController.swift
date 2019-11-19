//
//  ViewController.swift
//  RunningBack
//
//  Created by FanFan on 2019/11/19.
//  Copyright © 2019 g2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
    }


}

extension  ViewController{
    
    func setBarButtonItem() {
        let admin = UIBarButtonItem(image: UIImage(named: "ic_Admin"), style: .done, target: self, action: #selector(naviToAdmin))
        navigationItem.rightBarButtonItems = [admin]
    }
    
    @objc  func naviToAdmin() {
        let storyboard = UIStoryboard(name: "Admin", bundle: nil)
        let setTabBar = storyboard.instantiateViewController(identifier: "AdminNC") as! AdminNC
        setTabBar.modalPresentationStyle = .fullScreen
        navigationController?.removeFromParent()
        present(setTabBar, animated: true, completion: nil)
    }
    
    
}
