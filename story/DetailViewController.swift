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
    var avcfj = ApiCosts()
    var restIncome : RestIncomes = RestIncomes()
    var avclfj = ApiIncomes()
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
    @IBOutlet weak var dateTextView: UITextView!
    @IBOutlet weak var valueTextView: UITextView!
    @IBOutlet weak var typeTextView: UITextView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var infoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad, typeOfElement: ", typeOfElement)
        titleLabel.text = typeOfElement.uppercased()
        
        dateTextView.layer.borderWidth = 0.25
        dateTextView.vert
        valueTextView.layer.borderWidth = 0.25
        typeTextView.layer.borderWidth = 0.25
        nameTextView.layer.borderWidth = 0.25
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
            dateText.isHidden = true
            dateText.text = "2023-01-01"
            valueText.isHidden = true
            valueText.text = "1234.56"
            typeText.isHidden = true
            typeText.text = "przy"
            nameText.isHidden = true
            nameText.text = "nazwa"
            infoText.isHidden = true
            infoText.text = "opis"
            dateTextView.isHidden = false
            dateTextView.text = "2023-01-01"
            valueTextView.isHidden = false
            valueTextView.text = "1234.56"
            typeTextView.isHidden = false
            typeTextView.text = "przy"
            nameTextView.isHidden = false
            nameTextView.text = "nazwa"
            infoTextView.isHidden = false
            infoTextView.text = "opis"
            if typeOfElement == "Cost" {
                restCost.getvCost(urlLink: linkToRest){
                    print("get data from restCost")
                    self.dateText.text! = self.restCost.acv.date
                    self.valueText.text! = String(self.restCost.acv.value)
                    self.typeText.text! = String(self.restCost.acv.type)
                    self.nameText.text! = self.restCost.acv.name
                    self.infoText.text! = self.restCost.acv.info
                    self.dateTextView.text! = self.restCost.acv.date
                    self.valueTextView.text! = String(self.restCost.acv.value)
                    self.typeTextView.text! = String(self.restCost.acv.type)
                    self.nameTextView.text! = self.restCost.acv.name
                    self.infoTextView.text! = self.restCost.acv.info
                }
            } else if typeOfElement == "Income" {
                restIncome.getvIncome(urlLink: linkToRest){
                    print("get data from restIncome")
                    self.dateText.text! = self.restIncome.aiv.date
                    self.valueText.text! = String(self.restIncome.aiv.value)
                    self.typeText.text! = String(self.restIncome.aiv.type)
                    self.nameText.text! = self.restIncome.aiv.name
                    self.infoText.text! = self.restIncome.aiv.info
                    self.dateTextView.text! = self.restIncome.aiv.date
                    self.valueTextView.text! = String(self.restIncome.aiv.value)
                    self.typeTextView.text! = String(self.restIncome.aiv.type)
                    self.nameTextView.text! = self.restIncome.aiv.name
                    self.infoTextView.text! = self.restIncome.aiv.info
                }
            }
        } else if typeOfElement == "CostType" || typeOfElement == "IncomeType" {
            dateLabel.isHidden = true
            dateLabel.text = "Name"
            valueLabel.isHidden = true
            valueLabel.text = "Info"
            typeLabel.isHidden = true
            nameLabel.isHidden = true
            infoLabel.isHidden = true
            dateText.isHidden = true
            dateText.text = "Nazwa"
            valueText.isHidden = true
            valueText.text = "Rodzaj"
            typeText.isHidden = true
            nameText.isHidden = true
            infoText.isHidden = true
            dateTextView.isHidden = false
            dateTextView.text = "Name"
            valueTextView.isHidden = false
            valueTextView.text = "Info"
            typeTextView.isHidden = true
            nameTextView.isHidden = true
            infoTextView.isHidden = true
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
            dateText.isHidden = true
            dateText.text = "2023-01-01"
            valueText.isHidden = true
            valueText.text = "1234.56"
            typeText.isHidden = true
            typeText.text = "przy"
            nameText.isHidden = true
            nameText.text = "nazwa"
            infoText.isHidden = true
            infoText.text = "opis"
            dateTextView.isHidden = false
            dateTextView.text = "2023-01-01"
            valueTextView.isHidden = false
            valueTextView.text = "1234.56"
            typeTextView.isHidden = false
            typeTextView.text = "przy"
            nameTextView.isHidden = false
            nameTextView.text = "nazwa"
            infoTextView.isHidden = false
            infoTextView.text = "opis"
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
