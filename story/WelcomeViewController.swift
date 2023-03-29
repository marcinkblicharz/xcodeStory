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
//    var restCosts = RestCosts()
//    var link : String =  "" //"http://localhost:8080/rest/getCosts?from=2023-03-13"
//    var acl : [ApiCosts] = []
//    var acl = [ApiCosts]()
//    var acll = [ApiCosts]()
    
    private var viewModel = CostViewModel()
    
    @IBOutlet weak var tableCosts: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
//    var RCost = RestCosts()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let link : String = "http://localhost:8080/rest/getCosts?from=2023-03-13"
//        link = "http://localhost:8080/rest/getCosts?from=2023-03-13"
//
//        print("link from started is: " + link)
        
//        getJsonData { [weak self] in
//            self?.acll.d
//        }
        
        welcomeLabel.text = "Hi \(login), welcome in App!"
        loadJsonData()
//        restCosts.getLastCosts(urlLink: link) { (result) in
//            print(result)
////            print(result.get().count)
////            try acl = result.get()
//        }
//        print("size of costs: " + String(restCosts.vm_costs.count))
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
    
    private func loadJsonData() {
        viewModel.fetchJsonData { [weak self] in
            self?.tableCosts.dataSource = self
            self?.tableCosts.reloadData()
        }
//        fetchJsonData { [weak self] in
//            self?.tableCosts.dataSource = self
//            self?.tableCosts.reloadData()
//        }
    }

}
