import UIKit

class ManageInsertVC: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource{
    var job_no = ""
    var job = ""
    let url_server = URL(string: common_url + "ManageServlet")
    var manageList = ["管理員","客服","商品部"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var tfNo: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var btJob: UIButton!
    @IBOutlet weak var tfId: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10).isActive = true
        let c = myView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 300)
        c.identifier = "bottom"
        c.isActive = true
        myView.layer.cornerRadius = 10
        super.viewWillAppear(animated)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return manageList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return manageList[row]
    }
    
    @IBAction func btConfirm(_ sender: Any) {
        var requestParam = [String: String]()
        let name = tfName.text == nil ? "" : tfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let no = tfNo.text == nil ? "" : tfNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let id = tfId.text == nil ? "" : tfId.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let pw = tfPassword.text == nil ? "" : tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch job{
        case "管理員":
            job_no = "1"
        case "客服":
            job_no = "2"
        case "商品部":
            job_no = "3"
        default:
            job_no = ""
        }
        
        if(name == "" || no == "" || id == "" || pw == "" || job_no == ""){
            self.showSimpleAlert(message: "新增失敗", viewController: self)
        }else{
            let manage = Manage(job_no: job_no, emp_id: id, emp_pw: pw, emp_name: name, emp_no: no, job_name: "")
            
            requestParam["action"] = "manageInsert"
            requestParam["insert"] = try! String(data: JSONEncoder().encode(manage), encoding: .utf8)
            //    print("requestParam is ",requestParam)
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    // 新增成功則回前頁
                                    if count != 0 {                                    self.dismiss(animated:true, completion: nil)
                                    } else {
                                        
                                        self.showSimpleAlert(message: "新增失敗", viewController: self)
                                        
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
    }
    
    @IBAction func selectClick(_ sender: Any) {
        displayPickerView(true)
    }
    
    @IBAction func doneClick(_ sender: Any) {
        let title = manageList[pickerView.selectedRow(inComponent: 0)]
        btJob.setTitle(title, for: .normal)
        displayPickerView(false)
        job = title
    }
    
    func showSimpleAlert(message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "確認", style: .default)
        alertController.addAction(cancel)
        /* 呼叫present()才會跳出Alert Controller */
        viewController.present(alertController, animated: true, completion:nil)
    }
    
    func displayPickerView(_ show: Bool){
        for c in view.constraints{
            if c.identifier == "bottom"{
                c.constant = (show) ? -10 : 300
                break
            }
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btCancel(_ sender: Any) {
        dismiss(animated:true, completion: nil)
        
    }
    
    
}
