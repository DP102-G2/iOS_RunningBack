import UIKit
class UserListTVC: PlateTVC,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    var users = [User]()
    let url_server = URL(string: common_url + "UserServlet")
    
    // 儲存搜尋結果資料
    var searchNames = [User]()
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
        refreshControl.addTarget(self, action: #selector(showAllUsers), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    override func viewDidAppear(_ animated: Bool) {
        login()
    }
    override func viewWillAppear(_ animated: Bool) {
        showAllUsers()
    }
    
    @objc func showAllUsers() {
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
        
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
              //   print("input: \(String(data: data!, encoding: .utf8)!)")
        
                    if let result = try? JSONDecoder().decode([User].self, from: data!) {
                        self.users = result
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
            return users.count
        }
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var user: User
        if search {
            user = searchNames[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        let cellId = "userCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
        cell.userName.text = user.user_name
        cell.userNo.text = user.user_no
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if text == "" {
            search = false
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchNames = users.filter({ (user) -> Bool in
                return user.user_name.uppercased().contains(text.uppercased())
            })
            search = true
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    /* 因為拉UITableViewCell與detail頁面連結，所以sender是UITableViewCell */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let user = users[indexPath!.row]
            let detailVC = segue.destination as! UserDetailVC
            detailVC.user = user
        }
    }


}
