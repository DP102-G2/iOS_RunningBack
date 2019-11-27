import Foundation
class OrderStatus: Codable {
var ord_no: String
var ord_status: String

public init(ord_no: String,ord_status: String){
    self.ord_no = ord_no
    self.ord_status = ord_status
}
}
