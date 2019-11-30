import Foundation
class Ad: Codable {
    var pro_no: String?
    var ad_no:Int?
    public init(pro_no: String,ad_no: Int){
        self.pro_no = pro_no
        self.ad_no = ad_no
    }
    
}
