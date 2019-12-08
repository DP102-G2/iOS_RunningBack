import UIKit

class PromotionVC: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lbName: UILabel!
    let url_server = URL(string: common_url + "promotionServlet")
    var promotion : Promotion!
    override func viewDidLoad() {
        super.viewDidLoad()
        tfName.text = promotion.pro_no
        lbName.text = "主打\(promotion.prom_no!)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btConfirm(_ sender: Any) {
        promotion.pro_no = tfName.text
        let requestParam = ["action": "promotionUpdate","promotion": try! String(data: JSONEncoder().encode(promotion), encoding: .utf8)]
        getdata(input: requestParam as [String : Any])
        
    }
    
    func getdata(input:[String : Any]) {
        executeTask(url_server!, input) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    self.tfName.text = self.promotion.pro_no
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.showSimpleAlert(message: "修改失敗", viewController: self)
                                }
                                
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func showSimpleAlert(message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "確認", style: .default)
        alertController.addAction(cancel)
        /* 呼叫present()才會跳出Alert Controller */
        viewController.present(alertController, animated: true, completion:nil)
    }
}
