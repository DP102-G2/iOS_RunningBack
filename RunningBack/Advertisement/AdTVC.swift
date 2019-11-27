import UIKit

class AdTVC: PlateTVC {
    var job_no = 0
    let url_server = URL(string: common_url + "adproductServlet")
    var ads = [Ad]()
    @IBOutlet weak var uiView1: UIImageView!
    @IBOutlet weak var uiView2: UIImageView!
    @IBOutlet weak var uiView3: UIImageView!
    @IBOutlet weak var adName1: UITextField!
    @IBOutlet weak var adName2: UITextField!
    @IBOutlet weak var adName3: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        tableViewAddRefreshControl()
    }

    /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllAds), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func showAllAds() {
        let requestParam = ["action" : "getAll","action": "getImage"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([Ad].self, from: data!) {
                        self.ads = result
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            /* 抓到資料後重刷table view */
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    @IBAction func btConfirm(_ sender: Any) {
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        showAllAds()
        job_no = getJob()
        if job_no == 0 {
            naviToLogin()
        }
        
    }
    
    // MARK: - Table view data source

  
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
