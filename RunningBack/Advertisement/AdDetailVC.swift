//
//  AdDetailVC.swift
//  RunningBack
//
//  Created by  明智 on 2019/11/30.
//  Copyright © 2019 g2. All rights reserved.
//

import UIKit

class AdDetailVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var myView: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    var ad: Ad!
    var ad_no: Int!
    var detailimage: UIImage?
    var imageUpload: UIImage?
    let url_server = URL(string: common_url + "adproductServlet")
    override func viewDidLoad() {
        super.viewDidLoad()
        tfName.text = ad.pro_no
        myView.image = detailimage
        
    }
    
    @IBAction func btConfirm(_ sender: Any) {
        ad.pro_no = tfName.text
        ad.ad_no = ad_no
        var requestParam = ["action": "adproductUpdate","adproduct": try! String(data: JSONEncoder().encode(ad), encoding: .utf8)]
        if self.imageUpload != nil {
            requestParam["imageBase64"] = self.imageUpload!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
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
                                    self.tfName.text = self.ad.pro_no
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                }
                                self.showSimpleAlert(message: "修改失敗", viewController: self)
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func clickPickerPicture(_ sender: Any) {
        imagePicker(type: .photoLibrary)
    }
    func imagePicker(type: UIImagePickerController.SourceType) {
        hideKeyboard()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let spotImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 拍照或挑選的照片視為要上傳更新的照片
            imageUpload = spotImage
            myView.image = spotImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickTakePicture(_ sender: Any) {
        imagePicker(type: .camera)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showSimpleAlert(message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "確認", style: .default)
        alertController.addAction(cancel)
        /* 呼叫present()才會跳出Alert Controller */
        viewController.present(alertController, animated: true, completion:nil)
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
extension AdDetailVC{
    func hideKeyboard() {
        tfName.resignFirstResponder()
    }
}
