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
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var RCost = RestCosts()

    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.text = "Hi \(login), welcome in App!"
        RCost.getCosts(urlLink: link)
        RCost.vm_costs
        var CostsList : [ApiCosts] = RCost.vm_costs
        CostsList = RCost.vm_costs
        print("CostsList size: " + String(CostsList.count))
        for ApiCosts in CostsList {
            print("Name: " + ApiCosts.name)
        }
        
//        ForEach(CostsList, id: \.cid){
//            ApiCosts in print("Name: " + ApiCosts.)
//        }
    }

}
