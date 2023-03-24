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
    var link : String = ""
    var restCosts = RestCosts()
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
//    var RCost = RestCosts()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("link from started is: " + link)
        
        welcomeLabel.text = "Hi \(login), welcome in App!"
        restCosts.getLastCosts(urlLink: link) { (result) in
            print(result)
        }
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

}
