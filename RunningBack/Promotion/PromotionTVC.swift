//
//  PromotionTVC.swift
//  RunningBack
//
//  Created by  明智 on 2019/11/29.
//  Copyright © 2019 g2. All rights reserved.
//

import UIKit

class PromotionTVC: UITableViewController {
    let url_server = URL(string: common_url + "promotionServlet")
    var promotions = [Promotion]()
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 換頁
        let promotionDetail = self.storyboard?.instantiateViewController(withIdentifier: "promotionDetail") as! PromotionVC
        
        let promotion = promotions[indexPath.row]
        promotion.prom_no = indexPath.row + 1
        promotionDetail.promotion = promotion
        self.navigationController?.pushViewController(promotionDetail, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllPromotion()
    }
    
    @objc func showAllPromotion() {
        let requestParam = ["action": "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([Promotion].self, from: data!) {
                        self.promotions = result
                        DispatchQueue.main.async {
                            self.lb1.text = self.promotions[0].pro_no
                            self.lb2.text = self.promotions[1].pro_no
                            self.lb3.text = self.promotions[2].pro_no
                            self.lb4.text = self.promotions[3].pro_no
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
}
