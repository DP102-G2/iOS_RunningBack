import UIKit

class AdTVC: PlateTVC {
    let url_server = URL(string: common_url + "adproductServlet")
    var ads = [Ad]()
    override func viewDidLoad() {
        super.viewDidLoad()
       // tableViewAddRefreshControl()
    }
    
    
    /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllAds), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {

        showAllAds()

    }
    
    
    @objc func showAllAds() {
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    //    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "adDetailVC") as! AdDetailVC
        
        let adDetail = ads[indexPath.row]
        adDetailVC.ad = adDetail
        adDetailVC.ad_no = indexPath.row + 1
        let cell = tableView.cellForRow(at: indexPath) as! AdCell
        adDetailVC.detailimage = cell.adView.image
        self.navigationController?.pushViewController(adDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ad = ads[indexPath.row]
        let cellId = "adCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! AdCell
//        print("indexPath.row ",indexPath.row)
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["pro_no"] = ad.pro_no
        requestParam["ad_no"] = indexPath.row + 1
        requestParam["imageSize"] = cell.frame.width / 4
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    cell.adView.image = image
                }
               
            } else {
                print(error!.localizedDescription)
            }
        }
        cell.lbPro_no.text = ad.pro_no
        return cell
        
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
