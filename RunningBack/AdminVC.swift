//
//  AdminVC.swift
//  RunningBack
//
//  Created by FanFan on 2019/11/20.
//  Copyright © 2019 g2. All rights reserved.
//

import UIKit

class AdminVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension AdminVC{
    func setBarButtonItem() {
        let main = UIBarButtonItem(image: UIImage(named: "ic_Main"), style: .done, target: self, action: #selector(naviToMain))
        navigationItem.rightBarButtonItems = [main]
    }
    
    @objc  func naviToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let setTabBar = storyboard.instantiateViewController(identifier: "MainTBC") as! MainTBC
        setTabBar.modalPresentationStyle = .fullScreen
        navigationController?.removeFromParent()
        present(setTabBar, animated: true, completion: nil)
    }
}
