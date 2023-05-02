//
//  DetailViewController.swift
//  story
//
//  Created by Marcin Blicharz on 27/04/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var typeOfElement : String = ""
    var linkToRest : String = ""
    var restCost : RestCosts = RestCosts()
    var acfj = ApiCost()
    var aclfj = ApiCosts()
    var restIncome : RestIncomes = RestIncomes()
    var restCostType : RestCostTypes = RestCostTypes()
    var restIncomeType : RestIncomeTypes = RestIncomeTypes()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var Save: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var valueText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var infoText: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad, typeOfElement: ", typeOfElement)
        titleLabel.text = typeOfElement.uppercased()
        
        infoTextView.layer.borderWidth = 0.25
        
        if typeOfElement == "Cost" || typeOfElement == "Income" {
            dateLabel.isHidden = false
            dateLabel.text = "Date"
            valueLabel.isHidden = false
            valueLabel.text = "Amount"
            typeLabel.isHidden = false
            typeLabel.text = "Type"
            nameLabel.isHidden = false
            nameLabel.text = "Name"
            infoLabel.isHidden = false
            infoLabel.text = "Info"
            dateText.isHidden = false
            dateText.text = "2023-01-01"
            valueText.isHidden = false
            valueText.text = "1234.56"
            typeText.isHidden = false
            typeText.text = "przy"
            nameText.isHidden = false
            nameText.text = "nazwa"
            infoText.isHidden = false
            infoText.text = "opis"
            if typeOfElement == "Cost" {
                restCost.getCost(urlLink: linkToRest){
                    print("get data from restCost")
                    self.dateText.text! = self.restCost.ac.date
                    self.valueText.text! = String(self.restCost.ac.value)
                    self.typeText.text! = String(self.restCost.ac.fkCostType)
                    self.nameText.text! = self.restCost.ac.name
                    self.infoText.text! = self.restCost.ac.info
                    self.infoTextView.text! = self.restCost.ac.info
                }
            } else if typeOfElement == "Income" {
                restIncome.getIncome(urlLink: linkToRest){
                    print("get data from restCost")
                    self.dateText.text! = self.restIncome.ai.date
                    self.valueText.text! = String(self.restIncome.ai.value)
                    self.typeText.text! = String(self.restIncome.ai.fkIncomeType)
                    self.nameText.text! = self.restIncome.ai.name
                    self.infoText.text! = self.restIncome.ai.info
                    self.infoTextView.text! = self.restIncome.ai.info
                }
            }
        } else if typeOfElement == "CostType" || typeOfElement == "IncomeType" {
            dateLabel.isHidden = false
            dateLabel.text = "Name"
            valueLabel.isHidden = false
            valueLabel.text = "Info"
            typeLabel.isHidden = true
            nameLabel.isHidden = true
            infoLabel.isHidden = true
            dateText.isHidden = false
            dateText.text = "2023-01-01"
            valueText.isHidden = false
            valueText.text = "1234.56"
            typeText.isHidden = true
            nameText.isHidden = true
            infoText.isHidden = true
        } else {
            dateLabel.isHidden = false
            dateLabel.text = "Date"
            valueLabel.isHidden = false
            valueLabel.text = "Amount"
            typeLabel.isHidden = false
            typeLabel.text = "Type"
            nameLabel.isHidden = false
            nameLabel.text = "Name"
            infoLabel.isHidden = false
            infoLabel.text = "Info"
            dateText.isHidden = false
            dateText.text = "2023-01-01"
            valueText.isHidden = false
            valueText.text = "1234.56"
            typeText.isHidden = false
            typeText.text = "przy"
            nameText.isHidden = false
            nameText.text = "nazwa"
            infoText.isHidden = false
            infoText.text = "opis"
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
