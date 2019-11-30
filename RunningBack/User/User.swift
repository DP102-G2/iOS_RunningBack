import Foundation
class User: Codable {
    var user_name: String
    var user_no:   String
    var user_id: String
    var user_pw: String
    var user_email: String
    var user_regtime: String

    public init(user_no: String,user_name: String,user_id: String,user_pw: String,user_email: String, user_regtime: String){
        self.user_name = user_name
        self.user_no = user_no
        self.user_pw = user_pw
        self.user_id = user_id
        self.user_email = user_email
        self.user_regtime = user_regtime
    }
}
