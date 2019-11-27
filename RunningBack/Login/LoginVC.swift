import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var tfId: UITextField!
    @IBOutlet weak var tfPw: UITextField!
    let url_server = URL(string: "\(common_url)LoginServlet")
    var login:Login?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btConfirm(_ sender: Any) {
        let id = tfId.text == nil ? "" : tfId.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pw = tfPw.text == nil ? "" : tfPw.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var login = Login(job_no: 0, password: pw, id: id)
        
        var requestParam = [String:String]()
        requestParam["action"] = "getLogin"
        requestParam["login"] = try! String(data: JSONEncoder().encode(login), encoding: .utf8)
        //    print("requestParam is ",requestParam)
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let mLogin = try? JSONDecoder().decode(Login.self, from: data!){
                        login = mLogin
                        DispatchQueue.main.sync {
                            UserDefaults.standard.set(login.job_no, forKey: "job_no")
                            self.naviToRun(VC: self)
                        }
                    }else{
                        DispatchQueue.main.sync {
                            self.showSimpleAlert(message: "登入失敗", viewController: self)
                        }
                        
                    }
                    
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func naviToRun(VC : UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let setTabBar = storyboard.instantiateViewController(identifier: "MainTBC") as! MainTBC
        setTabBar.modalPresentationStyle = .fullScreen
        present(setTabBar, animated: true, completion: nil)
    }
    
    func showSimpleAlert(message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "確認", style: .default)
        alertController.addAction(cancel)
        /* 呼叫present()才會跳出Alert Controller */
        viewController.present(alertController, animated: true, completion:nil)
    }

}
