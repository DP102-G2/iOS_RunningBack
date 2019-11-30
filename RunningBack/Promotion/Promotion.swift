import Foundation
class Promotion: Codable {
    var pro_no: String?
    var prom_no: Int?
    public init(pro_no: String,prom_no: Int){
        self.pro_no = pro_no
        self.prom_no = prom_no
    }
    
}
