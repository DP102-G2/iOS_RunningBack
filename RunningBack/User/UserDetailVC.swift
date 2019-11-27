import UIKit

class UserDetailVC: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var lbNo: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var lbPassword: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var user: User!
    var orderstatus = [OrderStatus]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lbNo.text = user.user_no
        lbName.text = user.user_name
        lbId.text = user.user_id
        lbPassword.text = user.user_pw
        lbEmail.text = user.user_email
        lbTime.text = user.user_regtime
         tableViewAddRefreshControl()
    }
    
    func tableViewAddRefreshControl() {
          let refreshControl = UIRefreshControl()
          refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
          refreshControl.addTarget(self, action: #selector(showAllOrders), for: .valueChanged)
          self.tableView.refreshControl = refreshControl
      }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllOrders()
    }
    
    let url_server = URL(string: common_url + "UserOrderServlet")
    
    @objc func showAllOrders(){
        let requestParam = ["action": "getAll","getorder": user.user_no]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil{
                if data != nil{
                    if let result = try?
                        JSONDecoder().decode([OrderStatus].self,from: data!){
                        self.orderstatus = result
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl{
                                if control.isRefreshing{
                                    control.endRefreshing()
                                }
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
                else{
                    print(error!.localizedDescription)
                }
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return orderstatus.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var orderstatu: OrderStatus
        let cellId = "userorderCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserOrderCell
        orderstatu = orderstatus[indexPath.row]
        cell.userOrder.text = orderstatu.ord_no
        let ordresult: String
        switch orderstatu.ord_status{
        case "0":
             ordresult = "未完成付款"
        case "1":
             ordresult = "未處理"
        case "2":
             ordresult = "未寄出"
        case "3":
             ordresult = "已寄出"
        case "4":
             ordresult = "已取貨"
        default:
             ordresult = ""
        }
        
        cell.userOrderstatus.text = ordresult
        return cell
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
