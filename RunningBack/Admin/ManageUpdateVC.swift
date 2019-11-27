import UIKit

class ManageUpdateVC: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btJob: UIButton!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var tfPw: UITextField!
    @IBOutlet weak var lbNo: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lbId: UILabel!
    var manage: Manage!
    var job_no = ""
    var job = ""
    let url_server = URL(string: common_url + "ManageServlet")
    var manageList = ["管理員","客服","商品部"]
    override func viewDidLoad() {
        lbNo.text = manage.emp_no
        tfName.text = manage.emp_name
        btJob.setTitle(manage.job_name,for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllManage()
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
        //        let jsonData = try! JSONEncoder().encode(manageall)
        //        print("input: \(String(data: jsonData, encoding: .utf8)!)")
        var requestParam = [String: String]()
        manage.emp_no = lbNo.text
        manage.emp_name = tfName.text
        manage.emp_pw = tfPw.text
        
        switch job{
        case "管理員":
             job_no = "1"
        case "客服":
             job_no = "2"
        case "商品部":
             job_no = "3"
        default:
            job_no = manage.job_no!
        }
             
        manage.job_no = job_no
        requestParam["action"] = "manageUpdate"
        requestParam["update"] = try! String(data: JSONEncoder().encode(self.manage), encoding: .utf8)
      //  print("requestParam is ",requestParam)
        //        let requestParam = ["action": "manageUpdate","update": "\(jsonData)"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {                                   self.navigationController?.popViewController(animated: true)
                                } else {
                                 print("updata fail")
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
    @IBAction func btCancel(_ sender: Any) {
        // dismiss(animated:true, completion: nil)
        let adminTVC = self.storyboard?.instantiateViewController(withIdentifier: "adminTVC") as! AdminTVC
        self.navigationController?.pushViewController(adminTVC, animated: true)
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
    
    @objc func showAllManage() {
        let requestParam = ["action": "manageSearch","search": manage.emp_no]
        executeTask(url_server!, requestParam as [String : Any]) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode(Manage.self, from: data!) {
                        self.manage = result
                        DispatchQueue.main.async {
                            self.lbId.text = self.manage.emp_id
                            self.tfPw.text = self.manage.emp_pw
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    
    
}
