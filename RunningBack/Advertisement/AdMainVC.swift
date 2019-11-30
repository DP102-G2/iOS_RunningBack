//
//  AdMainVC.swift
//  RunningBack
//
//  Created by  明智 on 2019/11/28.
//  Copyright © 2019 g2. All rights reserved.
//

import UIKit

class AdMainVC: PlateVC {
    @IBOutlet var myView: [UIView]!
    var job_no = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        self.myView[0].isHidden = false
        self.myView[1].isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
        self.myView[0].isHidden.toggle()
        self.myView[1].isHidden.toggle()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let logout = UIBarButtonItem(image: UIImage(named: "ic_logout"), style: .done, target: self, action: #selector(naviToLogin))
        let admin = UIBarButtonItem(image: UIImage(named: "ic_Admin"), style: .done, target: self, action: #selector(naviToAdmin))
        
        job_no = getJob()
        if job_no == 1{
            navigationItem.rightBarButtonItems = [logout,admin]
        }
        else if job_no == 0 {
            naviToLogin()
        }
        
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
