//
//  DetailViewController.swift
//  story
//
//  Created by Marcin Blicharz on 27/04/2023.
//

import UIKit

class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var typeOfElement : String = ""
    var linkToRest : String = ""
    var restCost : RestCosts = RestCosts()
    var avcfj = ApiCosts()
    var restIncome : RestIncomes = RestIncomes()
    var avclfj = ApiIncomes()
    var restCostType : RestCostTypes = RestCostTypes()
    var restIncomeType : RestIncomeTypes = RestIncomeTypes()
    var costTypesList = [ApiCostTypes]()
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(identifier: "Europe/Amsterdam")
//        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    @IBOutlet weak var titleLabel: UILabel!
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
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var dateToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad, typeOfElement: ", typeOfElement)
        titleLabel.text = typeOfElement.uppercased()
        
        dateTextView.layer.borderWidth = 0.25
//        dateTextView.vert
        valueTextView.layer.borderWidth = 0.25
        typeTextView.layer.borderWidth = 0.25
        nameTextView.layer.borderWidth = 0.25
        infoTextView.layer.borderWidth = 0.25
        
        let dateClick = UITapGestureRecognizer(target: self, action: #selector(laDaAction))
        dateTextView.isUserInteractionEnabled = true
        dateTextView.addGestureRecognizer(dateClick)
        
        datePicker.maximumDate = Date()
        
        typePicker.dataSource = self
        typePicker.delegate = self
        
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
            datePicker.isHidden = true
            valueText.isHidden = true
            valueText.text = "1234.56"
            typeText.isHidden = true
            typeText.text = "przy"
            typePicker.isHidden = true
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
            updateButton.isHidden = false
            saveButton.isHidden = true
            cancelButton.isHidden = true
            dateToolbar.isHidden = true
            if typeOfElement == "Cost" {
                restCost.getvCost(urlLink: linkToRest){
                    print("get data from restCost")
                    self.dateText.text! = self.restCost.acv.date
                    let date = self.restCost.acv.date
                    self.datePicker.date = self.dateFormatter.date(from: date)!
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
                    let date = self.restIncome.aiv.date
                    self.datePicker.date = self.dateFormatter.date(from: date)!
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
            datePicker.isHidden = true
            valueText.isHidden = true
            valueText.text = "Rodzaj"
            typeText.isHidden = true
            typePicker.isHidden = true
            nameText.isHidden = true
            infoText.isHidden = true
            dateTextView.isHidden = false
            dateTextView.text = "Name"
            valueTextView.isHidden = false
            valueTextView.text = "Info"
            typeTextView.isHidden = true
            nameTextView.isHidden = true
            infoTextView.isHidden = true
            updateButton.isHidden = false
            saveButton.isHidden = true
            cancelButton.isHidden = true
            dateToolbar.isHidden = true
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
            datePicker.isHidden = true
            valueText.isHidden = true
            valueText.text = "1234.56"
            typeText.isHidden = true
            typeText.text = "przy"
            typePicker.isHidden = true
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
            updateButton.isHidden = false
            saveButton.isHidden = true
            cancelButton.isHidden = true
            dateToolbar.isHidden = true
        }
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        updateButton.isHidden = true
        saveButton.isHidden = false
        cancelButton.isHidden = false
        dateTextView.isHidden = false
        valueTextView.isHidden = true
        typeTextView.isHidden = true
        typeText.isHidden = true
        nameTextView.isHidden = true
        infoTextView.isHidden = true
        datePicker.isHidden = true
        valueText.isHidden = false
        dateToolbar.isHidden = true
        
        if typeOfElement == "Cost" || typeOfElement == "Income" {
            typePicker.isHidden = false
            nameText.isHidden = false
            infoText.isHidden = false
        } else if typeOfElement == "CostType" || typeOfElement == "IncomeType" {
            
        } else {
            
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func laDaAction(){
        if(saveButton.isHidden == false){
            print("laDaAction")
            if datePicker.isHidden == true && dateToolbar.isHidden == true {
                dateToolbar.isHidden = false
                datePicker.isHidden = false
            } else {
                dateToolbar.isHidden = true
                datePicker.isHidden = true
            }
        }
    }
    
    @IBAction func setDate(_ sender: UIBarButtonItem) {
        dateTextView.text = dateFormatter.string(from: datePicker.date)
        dateToolbar.isHidden = true
        datePicker.isHidden = true
    }
    
    @IBAction func todayDate(_ sender: UIBarButtonItem) {
        datePicker.date = Date()
    }
    
    @IBAction func cancelDate(_ sender: UIBarButtonItem) {
        dateToolbar.isHidden = true
        datePicker.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return costTypesList.count
    }
    
    func UIPickerViewDataSource () {
        
    }
    
    func UIPickerViewDelegate () {
        
    }
    
}
