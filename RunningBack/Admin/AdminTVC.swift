import UIKit

class AdminTVC: UITableViewController,UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    var manages = [Manage]()
    let url_server = URL(string: common_url + "ManageServlet")
    
    // 儲存搜尋結果資料
    var searchNames = [Manage]()
    // 是否要顯示搜尋後資料
    var search = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        tableViewAddRefreshControl()
    }
    
    /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllManage), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllManage()
    }
    
    @objc func showAllManage() {
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
          //    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode([Manage].self, from: data!) {
                        self.manages = result
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
        if search {
            return searchNames.count
        } else {
            return manages.count
        }
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var manage: Manage
        if search {
            manage = searchNames[indexPath.row]
        } else {
            manage = manages[indexPath.row]
        }
        let cellId = "manageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ManageCell
        cell.employeeName.text = manage.emp_name
        cell.employeeNo.text = manage.emp_no
        cell.employeeJob.text = manage.job_name
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if text == "" {
            search = false
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchNames = manages.filter({ (manage) -> Bool in
                return (manage.emp_name?.uppercased().contains(text.uppercased()) ?? false)
            })
            search = true
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // 左滑修改與刪除資料
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 左滑時顯示Edit按鈕
        let edit = UIContextualAction(style: .normal, title: "Edit", handler: { (action, view, bool) in
            let manageUpdateVC = self.storyboard?.instantiateViewController(withIdentifier: "manageUpdateVC") as! ManageUpdateVC
            let manage = self.manages[indexPath.row]
            manageUpdateVC.manage = manage
            self.navigationController?.pushViewController(manageUpdateVC, animated: true)
        })
        edit.backgroundColor = UIColor.lightGray
        edit.image = UIImage(named: "edit")
        // 左滑時顯示Delete按鈕
        let delete = UIContextualAction(style: .normal, title: "Delete", handler: { (action, view, bool) in
            // 尚未刪除server資料
            var requestParam = [String: Any]()
            requestParam["action"] = "manageDelete"
            requestParam["manageEmp_no"] = self.manages[indexPath.row].emp_no
            executeTask(self.url_server!, requestParam
                , completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    // 確定server端刪除資料後，才將client端資料刪除
                                    if count != 0 {
                                        self.manages.remove(at: indexPath.row)
                                        DispatchQueue.main.async {
                                            tableView.deleteRows(at: [indexPath], with: .fade)
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
            })
        })
        delete.backgroundColor = .red
        delete.image = UIImage(named: "delete")
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        // true代表滑到底視同觸發第一個動作；false代表滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}



extension AdminTVC{
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
