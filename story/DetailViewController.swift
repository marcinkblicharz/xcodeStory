//
//  DetailViewController.swift
//  story
//
//  Created by Marcin Blicharz on 27/04/2023.
//

import UIKit

class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var typeOfElement : String = ""
    var typeOfAction : String = ""
    var linkToRest : String = ""
    var restCost : RestCosts = RestCosts()
    var avcfj = ApiCosts()
    var restIncome : RestIncomes = RestIncomes()
    var avclfj = ApiIncomes()
    var restCostType : RestCostTypes = RestCostTypes()
    var restIncomeType : RestIncomeTypes = RestIncomeTypes()
    var costTypesList = [ApiCostTypes]()
    var incomeTypesList = [ApiIncomeTypes]()
    var serverAddress : String = ""
    var cid : Int = 0
    var ctid : Int = 0
    var iid : Int = 0
    var itid : Int = 0
    var delegate: WelcomeViewController? = WelcomeViewController()
    
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
    @IBOutlet weak var typeToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad, typeOfElement: ", typeOfElement, ", on action: ", typeOfAction)
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
        let typeClick = UITapGestureRecognizer(target: self, action: #selector(laTyAction))
        typeTextView.isUserInteractionEnabled = true
        typeTextView.addGestureRecognizer(typeClick)
        
        
        updateButton.setTitle("Update", for: .normal)
        
        datePicker.maximumDate = Date()
        
        typePicker.dataSource = self
        typePicker.delegate = self
        
        
        let sortedCostTypes = costTypesList.sorted{$0.type < $1.type}
        costTypesList = sortedCostTypes
        let sortedIncomeTypes = incomeTypesList.sorted{$0.type < $1.type}
        incomeTypesList = sortedIncomeTypes
        
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
            dateText.text = ""
            datePicker.isHidden = true
            valueText.isHidden = true
            valueText.text = ""
            typeText.isHidden = true
            typeText.text = ""
            typePicker.isHidden = true
            nameText.isHidden = true
            nameText.text = ""
            infoText.isHidden = true
            infoText.text = ""
            dateTextView.isHidden = false
            dateTextView.text = ""
            valueTextView.isHidden = false
            valueTextView.text = ""
            typeTextView.isHidden = false
            typeTextView.text = ""
            nameTextView.isHidden = false
            nameTextView.text = ""
            infoTextView.isHidden = false
            infoTextView.text = ""
            updateButton.isHidden = false
            saveButton.isHidden = true
            cancelButton.isHidden = true
            dateToolbar.isHidden = true
            typeToolbar.isHidden = true
            if typeOfAction == "edit" {
                print("prepare for edit element")
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
                        if self.restCost.acv.subtype.count > 0 {
                            self.typeTextView.text! = String(self.restCost.acv.type) + " - " + String(self.restCost.acv.subtype)
                        } else {
                            self.typeTextView.text! = String(self.restCost.acv.type)
                        }
                        self.nameTextView.text! = self.restCost.acv.name
                        self.infoTextView.text! = self.restCost.acv.info
                        self.cid = self.restCost.acv.cid
                        self.ctid = self.restCost.acv.ctid
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
                        if self.restIncome.aiv.source.count > 0 {
                            self.typeTextView.text! = String(self.restIncome.aiv.type) + " - " + String(self.restIncome.aiv.source)
                        } else {
                            self.typeTextView.text! = String(self.restIncome.aiv.type)
                        }
                        self.nameTextView.text! = self.restIncome.aiv.name
                        self.infoTextView.text! = self.restIncome.aiv.info
                        self.iid = self.restIncome.aiv.iid
                        self.itid = self.restIncome.aiv.itid
                    }
                }
            } else if typeOfAction == "add" {
                print("prepare for add element")
                updateButton.isHidden = false
                saveButton.isHidden = true
                cancelButton.isHidden = true
                dateTextView.isHidden = false
                valueTextView.isHidden = true
                typeTextView.isHidden = false
                typeText.isHidden = true
                nameTextView.isHidden = true
                infoTextView.isHidden = true
                datePicker.isHidden = true
                valueText.isHidden = false
                dateToolbar.isHidden = true
                nameText.isHidden = false
                infoText.isHidden = false
                updateButton.setTitle("Add", for: .normal)
                dateTextView.text = dateFormatter.string(from: Date())
                valueText.text = "0.00"
                if typeOfElement == "Cost" {
                    typeTextView.text = costTypesList[0].type
                } else if typeOfElement == "Income" {
                    typeTextView.text = incomeTypesList[0].type
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
            typeToolbar.isHidden = true
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
            typeToolbar.isHidden = true
        }
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        if typeOfAction == "edit" {
            updateButton.isHidden = true
            saveButton.isHidden = false
            cancelButton.isHidden = false
            dateTextView.isHidden = false
            valueTextView.isHidden = true
            typeTextView.isHidden = false
            typeText.isHidden = true
            nameTextView.isHidden = true
            infoTextView.isHidden = true
            datePicker.isHidden = true
            valueText.isHidden = false
            dateToolbar.isHidden = true
            
            if typeOfElement == "Cost" || typeOfElement == "Income" {
                nameText.isHidden = false
                infoText.isHidden = false
            } else if typeOfElement == "CostType" || typeOfElement == "IncomeType" {
                
            } else {
                
            }
        } else if typeOfAction == "add" {
            print("element adding")
            let type : String = "addButton - ACTION"
            var linkSend = "http://" + serverAddress + ":8080/rest/"
            if typeOfElement == "Cost" {
                print(type + " for Cost with ID: " + String(cid))
                print("\tDATE: ", dateTextView?.text!)
                print("\tAMOUNT: ", valueText?.text)
                print("\tTYPE: ", typeTextView?.text, ", ctid: ", String(ctid) + "'")
                print("\tNAME: ", nameText?.text)
                print("\tINFO: ", infoText?.text)
                print("link to send: '" + linkSend + "addCost")
                var jsonSend : ApiCost = ApiCost()
                jsonSend.id = cid as! Int
                jsonSend.name = nameText?.text as! String
                jsonSend.date = dateTextView?.text as! String
                jsonSend.info = infoText?.text as! String
                jsonSend.fkCostType = ctid as! Int
                jsonSend.value = Double((valueText?.text)!) as! Double
                print("jsonSend: ", jsonSend)
                let json: [String: Any] = ["fkCostType": String(ctid),
                                           "date":  (dateTextView?.text!)!,
                                           "value": String(Double((valueText?.text)!)!),
                                           "name": (nameText?.text)!,
                                           "info": (infoText?.text)!]
                restCost.putCost(urlLink: linkSend + "addCost", jsonSend: json) {
                }
            } else if typeOfElement == "Income" {
                print(type + " for Income with ID: " + String(iid))
                print("\tDATE: ", dateTextView?.text!)
                print("\tAMOUNT: ", valueText?.text)
                print("\tTYPE: ", typeTextView?.text, ", itid: ", String(itid))
                print("\tNAME: ", nameText?.text)
                print("\tINFO: ", infoText?.text)
                print("link to send: '" + linkSend + "addIncome")
                let json: [String: Any] = ["fkIncomeType": String(itid),
                                           "date":  (dateTextView?.text!)!,
                                           "value": String(Double((valueText?.text)!)!),
                                           "name": (nameText?.text)!,
                                           "info": (infoText?.text)!]
                restIncome.putIncome(urlLink: linkSend + "addIncome", jsonSend: json){
                }
            }
            delegate?.refreshView()
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func saveElementButton(_ sender: UIButton) {
        let type : String = "saveButton - ACTION"
        var linkSend = "http://" + serverAddress + ":8080/rest/"
        if typeOfElement == "Cost" {
            print(type + " for Cost with ID: " + String(cid))
            print("\tDATE: ", dateTextView?.text!)
            print("\tAMOUNT: ", valueText?.text)
            print("\tTYPE: ", typeTextView?.text, ", ctid: ", String(ctid) + "'")
            print("\tNAME: ", nameText?.text)
            print("\tINFO: ", infoText?.text)
            print("link to send: '" + linkSend + "putCost/" + String(cid))
            var jsonSend : ApiCost = ApiCost()
            jsonSend.id = cid as! Int
            jsonSend.name = nameText?.text as! String
            jsonSend.date = dateTextView?.text as! String
            jsonSend.info = infoText?.text as! String
            jsonSend.fkCostType = ctid as! Int
            jsonSend.value = Double((valueText?.text)!) as! Double
            print("jsonSend: ", jsonSend)
            let json: [String: Any] = ["fkCostType": String(ctid),
                                       "date":  (dateTextView?.text!)!,
                                       "value": String(Double((valueText?.text)!)!),
                                       "name": (nameText?.text)!,
                                       "info": (infoText?.text)!]
//            restCost.putCost(urlLink: linkSend + "putCost/" + String(cid), jsonSend: jsonSend) {
            restCost.putCost(urlLink: linkSend + "putCost/" + String(cid), jsonSend: json) {
            }
        } else if typeOfElement == "Income" {
            print(type + " for Income with ID: " + String(iid))
            print("\tDATE: ", dateTextView?.text!)
            print("\tAMOUNT: ", valueText?.text)
            print("\tTYPE: ", typeTextView?.text, ", itid: ", String(itid))
            print("\tNAME: ", nameText?.text)
            print("\tINFO: ", infoText?.text)
            print("link to send: '" + linkSend + "putIncome/" + String(iid) + "'")
            let json: [String: Any] = ["fkIncomeType": String(itid),
                                       "date":  (dateTextView?.text!)!,
                                       "value": String(Double((valueText?.text)!)!),
                                       "name": (nameText?.text)!,
                                       "info": (infoText?.text)!]
            restIncome.putIncome(urlLink: linkSend + "putIncome/" + String(iid), jsonSend: json){
            }
        }
        delegate?.tableCosts.reloadData()
//        delegate?.welcomeLabel.text = "sadem"
        delegate?.refreshView()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func laDaAction(){
        print("laDaAction")
        if(saveButton.isHidden == false || typeOfAction == "add"){
            if datePicker.isHidden == true && dateToolbar.isHidden == true {
                typePicker.isHidden = true
                typeToolbar.isHidden = true
                dateToolbar.isHidden = false
                datePicker.isHidden = false
            } else {
                dateToolbar.isHidden = true
                datePicker.isHidden = true
            }
        }
    }
    
    @objc func laTyAction(){
//        typeTextView.isUserInteractionEnabled = false
//        typeTextView.isEditable = false
//        typeTextView.isSelectable = false
        if typeOfAction == "edit" {
            if typeOfElement == "Cost" {
                var selectId : Int = -1
                for i in 0...costTypesList.count-1 {
                    if costTypesList[i].id == self.restCost.acv.ctid {
                        selectId = i
                    }
                }
                typePicker.selectRow(selectId, inComponent: 0, animated: false)
            } else if typeOfElement == "Income" {
                var selectId : Int = -1
                for i in 0...incomeTypesList.count-1 {
                    if incomeTypesList[i].id == self.restIncome.aiv.itid {
                        selectId = i
                    }
                }
                typePicker.selectRow(selectId, inComponent: 0, animated: false)
            }
        } else if typeOfAction == "add" {
            typePicker.selectRow(0, inComponent: 0, animated: false)
        }
        if(saveButton.isHidden == false || typeOfAction == "add"){
            print("laTyAction")
            if typePicker.isHidden == true {
                dateToolbar.isHidden = true
                datePicker.isHidden = true
                typePicker.isHidden = false
                typeToolbar.isHidden = false
            } else {
                typePicker.isHidden = true
                typeToolbar.isHidden = true
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
    
    @IBAction func setType(_ sender: UIBarButtonItem) {
        if typeOfElement == "Cost" {
            let type = costTypesList[typePicker.selectedRow(inComponent: 0)].type
            let subtype = costTypesList[typePicker.selectedRow(inComponent: 0)].subtype
            ctid = costTypesList[typePicker.selectedRow(inComponent: 0)].id
            var name : String = ""
            if subtype.count > 0 {
                name = type + " - " + subtype
            } else {
                name = type
            }
            typeTextView.text = name
            print("type of Cost: " + name)
        } else if typeOfElement == "Income" {
            let type = incomeTypesList[typePicker.selectedRow(inComponent: 0)].type
            let source = incomeTypesList[typePicker.selectedRow(inComponent: 0)].source
            itid = incomeTypesList[typePicker.selectedRow(inComponent: 0)].id
            var name : String = ""
            if source.count > 0 {
                name = type + " - " + source
            } else {
                name = type
            }
            typeTextView.text = name
            print("type of Income: " + name)
        }
        typePicker.isHidden = true
        typeToolbar.isHidden = true
    }
    
    @IBAction func cancelType(_ sender: UIBarButtonItem) {
        typePicker.isHidden = true
        typeToolbar.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if typeOfElement == "Cost" {
            return costTypesList.count
        } else if typeOfElement == "Income" {
            return incomeTypesList.count
        } else {
            return costTypesList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if typeOfElement == "Cost" {
//            let sortedCostTypes = costTypesList.sorted{$0.type < $1.type}
//            costTypesList = sortedCostTypes
            if costTypesList[row].subtype.count > 0 {
                return costTypesList[row].type + " - " + costTypesList[row].subtype
            } else {
                return costTypesList[row].type
            }
        } else if typeOfElement == "Income" {
//            let sortedIncomeTypes = incomeTypesList.sorted{$0.type < $1.type}
//            incomeTypesList = sortedIncomeTypes
            if incomeTypesList[row].source.count > 0 {
                return incomeTypesList[row].type + " - " + incomeTypesList[row].source
            } else {
                return incomeTypesList[row].type
            }
        } else {
//            let sortedCostTypes = costTypesList.sorted{$0.type < $1.type}
//            costTypesList = sortedCostTypes
            if costTypesList[row].subtype.count > 0 {
                return costTypesList[row].type + " - " + costTypesList[row].subtype
            } else {
                return costTypesList[row].type
            }
        }
    }
    
    func UIPickerViewDataSource () {
        
    }
    
    func UIPickerViewDelegate () {
        
    }
    
}
