//
//  WelcomeViewController.swift
//  story
//
//  Created by Marcin Blicharz on 07/02/2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var login : String = ""
    var password : String = ""
    var restCosts = RestCosts()
    var link : String =  "http://localhost:8080/rest/getCosts?from=2023-03-20"
//    var acl : [ApiCosts] = []
//    var acl = [ApiCosts]()
//    var acll = [ApiCosts]()
    var aclfj = [ApiCosts]()
    var list_size : Int = 0
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
//        "date": "2023-03-12T23:00:00.000+00:00",
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    private var viewModel = CostViewModel()
    
    @IBOutlet weak var tableCosts: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
//    var RCost = RestCosts()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let link : String = "http://localhost:8080/rest/getCosts?from=2023-03-13"
        link = "http://localhost:8080/rest/getCosts?from=2023-03-13"
//
//        print("link from started is: " + link)
        
//        getJsonData { [weak self] in
//            self?.acll.d
//        }
        
        welcomeLabel.text = "Hi \(login), welcome in App!"
//        loadJsonData()
        print("Link: " + link)
//        getCosts(urlLink: link){
//            print("Get data from JSON with success!")
//            print("Size of aclfj is: " + String(self.aclfj.count))
//        }
        restCosts.getCostsInner(urlLink: link){
            print("Get data from JSON with success!")
            self.aclfj = self.restCosts.acl
            self.list_size = self.aclfj.count
            print("Size of aclfj is: " + String(self.list_size))
            if self.list_size > 0 {
                print("aclfj[0] (date): ", self.aclfj[0].date)
            } else {
                print("aclfj 0 sized")
            }
        }
//        restCosts.getLastCosts(urlLink: link) { (result) in
//            print(result)
////            print(result.get().count)
////            try acl = result.get()
//        }
////        print("size of costs: " + String(restCosts.vm_costs.count))
//        print("size of acl: " + String(acl.count))
//        RCost.getCosts(urlLink: link)
//        RCost.vm_costs
//        var CostsList : [ApiCosts] = RCost.vm_costs
//        CostsList = RCost.vm_costs
//        print("CostsList size: " + String(CostsList.count))
//        for ApiCosts in CostsList {
//            print("Name: " + ApiCosts.name)
//        }
        
//        ForEach(CostsList, id: \.cid){
//            ApiCosts in print("Name: " + ApiCosts.)
//        }
    }
    
//    private func loadJsonData() {
//        viewModel.fetchJsonData { [weak self] in
//            self?.tableCosts.dataSource = self
//            self?.tableCosts.reloadData()
//        }
////        fetchJsonData { [weak self] in
////            self?.tableCosts.dataSource = self
////            self?.tableCosts.reloadData()
////        }
//    }
    
//ADDITIONAL
    func getCosts(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.aclfj = try JSONDecoder().decode([ApiCosts].self, from: data!)
                } catch {
                    print("error get data from api")
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }

//    func getCosts(urlLink : String){

////        let decoder = JSONDecoder()
////        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//
//        guard let url = URL(string: urlLink) else {
//            return
//        }
//
////        print("vm_costs (initial) size is: " + String(aclfj.count) + " for link: " + urlLink)
//
//        let task = URLSession.shared.dataTask(with : url) { [weak self] data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//
//            do {
//                let costs = try JSONDecoder().decode([ApiCosts].self, from: data)
//                DispatchQueue.main.async {
//                    self?.aclfj = costs
////                    print(costs)
//                }
//
//            } catch {
//                print(error)
//            }
//        }
//
//        print("vm_costs (final) size is: " + String(aclfj.count))
//
//        task.resume()
//    }

}

//extension WelcomeViewController: UITableViewDataSource {
//    func tableView(_ tableCosts: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfRowsInSection(section: section)
//    }
//    
////    func tableView(_ tableCosts: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableCosts.dequeueReusableCell(withIdentifier: "cell", for: indexPath) //as! CostTableViewCell
////
////        let ApiCosts = viewModel.cellForRowAt(indexPath: indexPath)
////        cell.setCellWithValuesOf(ApiCosts)
////
////        return cell
////    }
//}
