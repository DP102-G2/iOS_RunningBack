//
//  Login.swift
//  RunningBack
//
//  Created by  明智 on 2019/11/26.
//  Copyright © 2019 g2. All rights reserved.
//

import Foundation
class Login :Codable{
    var job_no: Int?
    var password: String?
    var id: String?
    
    init(job_no:Int,password:String,id:String) {
        self.id = id
        self.job_no = job_no
        self.password = password
    }
    
    
    
    
}
