//
//  ViewController.swift
//  Test
//
//  Created by Kavya on 09/07/22.
//

import UIKit
import CoreData
import Kingfisher

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let serviceObj = ServiceConnection()
    var manageObjectContext: NSManagedObjectContext!
    var employee: Employee?
    var coredataList : [Employee] = []
    var filteredData : [Employee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tableView.delegate = self
        searchBar.delegate = self
        tableView.dataSource = self
        fetchCoreData()
    }
    
    //Fetching data from coreData
    func fetchCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: self.manageObjectContext!)
        fetchRequest.entity = entity
        self.coredataList = try! self.manageObjectContext!.fetch(fetchRequest) as! [Employee]
        
        if self.coredataList.count == 0 {
            getData()
        }else{
            self.filteredData = coredataList
            self.tableView.reloadData()
            print("Yaaay!!")
        }
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? coredataList : coredataList.filter({
            (($0.name ?? "").lowercased()).contains(searchText.lowercased())
            || (($0.email ?? "").lowercased()).contains(searchText.lowercased()) })
        tableView.reloadData()
    }
    //Getting data from service and set the data to CoreData
    func getData() {
        serviceObj.GetData() { (response) in
            for item in response {
                let id: Int16 = item["id"] as! Int16
                let name: String? = item["name"] as? String
                let username: String? = item["username"] as? String
                let email: String? = item["email"] as? String
                let profile_image: String? = item["profile_image"] as? String
                var street: String? = nil
                var suite: String? = nil
                var city: String? = nil
                var zipcode: String? = nil
                var lat: String? = nil
                var lng: String? = nil
                if let address = item["address"] as? [String : Any]{
                    street = address["street"] as? String
                    suite = address["suite"] as? String
                    city = address["city"] as? String
                    zipcode = address["zipcode"] as? String
                    if let geo = address["geo"] as? [String : Any] {
                        lat = geo["lat"] as? String
                        lng = geo["lng"] as? String
                    }
                }
                let phone: String? = item["phone"] as? String
                let website: String? = item["website"] as? String
                var companyname: String? = nil
                var catchPhrase: String? = nil
                var bs: String? = nil
                if let company = item["company"] as? [String : Any]{
                    companyname = company["name"] as? String
                    catchPhrase = company["catchPhrase"] as? String
                    bs = company["bs"] as? String
                }
                //Adding data to coreData
                let entity = NSEntityDescription.entity(forEntityName: "Employee", in: self.manageObjectContext!)
                self.employee = Employee(entity: entity!, insertInto: self.manageObjectContext!)
                self.employee?.id = id
                self.employee?.name = name
                self.employee?.username = username
                self.employee?.email = email
                self.employee?.profile_image = profile_image
                self.employee?.street = street
                self.employee?.suite = suite
                self.employee?.city = city
                self.employee?.zipcode = zipcode
                self.employee?.lat = lat
                self.employee?.lng = lng
                self.employee?.phone = phone
                self.employee?.website = website
                self.employee?.companyname = companyname
                self.employee?.catchPhrase = catchPhrase
                self.employee?.bs = bs
            }
            do{
                //Saving data to coredata
                try self.manageObjectContext!.save()
            }catch{
                print("Data saving error", error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.fetchCoreData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.lbl1.text = filteredData[indexPath.row].name
        cell.lbl2.text = filteredData[indexPath.row].companyname ?? "No CompanyName"
        cell.img.contentMode = .scaleAspectFill
        cell.img.layer.cornerRadius = 25
        cell.img.kf.setImage(with: URL(string: filteredData[indexPath.row].profile_image ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRok_BUdv1oJkVi09IkXw3IpMA1F2SN2FUCvA&usqp=CAU"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        vc.employee = filteredData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

