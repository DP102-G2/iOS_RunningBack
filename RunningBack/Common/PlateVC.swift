//
//  PlateVC.swift
//  RunningBack
//
//  Created by  明智 on 2019/11/29.
//  Copyright © 2019 g2. All rights reserved.
//

import UIKit

class PlateVC: UIViewController {
    
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
extension PlateVC{
    func setBarButtonItem() {
        let logout = UIBarButtonItem(image: UIImage(named: "ic_logout"), style: .done, target: self, action: #selector(naviToLogin))
        navigationItem.rightBarButtonItems = [logout]
    }
    
    // 切換storyboard的func
    @objc  func naviToAdmin() {
        let storyboard = UIStoryboard(name: "Admin", bundle: nil)
        let setTabBar = storyboard.instantiateViewController(identifier: "AdminNC") as! AdminNC
        setTabBar.modalPresentationStyle = .fullScreen
        present(setTabBar, animated: true, completion: nil)
    }
    
    @objc  func naviToLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginTabBar = storyboard.instantiateViewController(identifier: "LoginNavi") as! UINavigationController
        loginTabBar.modalPresentationStyle = .fullScreen
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        present(loginTabBar, animated: true, completion: nil)
    }
    
    /**
     抓取偏好設定裡面的user_no，
     ````
     let user_no = getUserNo()
     ````
     */
    func getJob() -> Int {
        var job_no = 0
        if let noStr = UserDefaults.standard.value(forKey: "job_no") {
            job_no = noStr as! Int
        } else {
            job_no = 0
        }
        return job_no
}
}
