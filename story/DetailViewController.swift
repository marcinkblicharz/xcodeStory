//
//  DetailViewController.swift
//  story
//
//  Created by Marcin Blicharz on 27/04/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var typeOfElement : String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var Save: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad, typeOfElement: ", typeOfElement)
        titleLabel.text = typeOfElement.uppercased()
        
        if typeOfElement == "Cost" {
            
        } else if typeOfElement == "Income" {
            
        } else if typeOfElement == "CostType" {
            
        } else if typeOfElement == "IncomeType" {
            
        } else {
            
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
