//
//  SecondViewController.swift
//  Test
//
//  Created by Kavya on 09/07/22.
//

import UIKit
import Kingfisher

class SecondViewController: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imge: UIImageView!
    
    var employee: Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imge.layer.cornerRadius = 75
        imge.kf.setImage(with: URL(string: employee.profile_image ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRok_BUdv1oJkVi09IkXw3IpMA1F2SN2FUCvA&usqp=CAU"))
        var text = "Name : - \(employee.name ?? "") \n\n"
        text += "UserName : - \(employee.username ?? "") \n\n"
        text += "Email : - \(employee.email ?? "") \n\n"
        text += "Address : - \(employee.street ?? ""), \(employee.suite ?? ""), \(employee.city ?? ""), \(employee.zipcode ?? "") \n\n"
        
        text += "Phone : - \(employee.phone ?? "") \n\n"
        text += "WebSite : - \(employee.website ?? "") \n\n"
        
        text += "Company : - \(employee.companyname ?? ""), \(employee.catchPhrase ?? ""), \(employee.bs ?? "") \n\n"
        lbl.text = text
    }
}
