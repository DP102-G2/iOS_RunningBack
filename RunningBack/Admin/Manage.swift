import Foundation
class Manage: Codable {
    var emp_no: String?
    var emp_name: String?
    var emp_pw: String?
    var emp_id: String?
    var job_no: String?
    var job_name: String?
    
    public init(job_no: String,emp_id: String,emp_pw: String,emp_name: String,emp_no: String,job_name: String){
        self.emp_no = emp_no
        self.emp_name = emp_name
        self.emp_id = emp_id
        self.emp_pw = emp_pw
        self.job_no = job_no
        self.job_name = job_name
    }
}


