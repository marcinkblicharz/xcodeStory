//
//  RestIncomes.swift
//  story
//
//  Created by Marcin Blicharz on 06/04/2023.
//

import Foundation

class RestIncomes : ObservableObject {
    
    private var dataTask : URLSessionDataTask?
    @Published var ail : [ApiIncomes] = []
    @Published var aiv : ApiIncomes = ApiIncomes()
    @Published var ai : ApiIncome = ApiIncome()
    
    func getIncomes(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.ail = try JSONDecoder().decode([ApiIncomes].self, from: data!)
                } catch {
                    print("error get data from api")
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    func getvIncome(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.aiv = try JSONDecoder().decode(ApiIncomes.self, from: data!)
                } catch {
                    print("error get data from api")
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    func getIncome(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.ai = try JSONDecoder().decode(ApiIncome.self, from: data!)
                } catch {
                    print("error get data from api")
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    func putIncome(urlLink : String, jsonSend : [String : Any], completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        let json : [String : Any] = jsonSend
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with : request) { data, response, error in
            if error == nil {
                do {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
//                    if let responseJSON = responseJSON as? [String : Any] {
//                        print(responseJSON)
//                    }
                } catch {
                    print("error put data to rest")
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    func delIncome(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with : request) { data, response, error in
            if error == nil {
                do {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                } catch {
                    print("error delete data to rest")
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
}

struct ApiIncomes : Decodable {
    var iid : Int
    var date: String   //must be Date
    var value : Double
    var name : String
    var info : String
    var itid : Int
    var type : String
    var source : String
    var color : String
    
    init(){
        self.iid = 0
        self.date = ""
        self.value = 0.0
        self.name = ""
        self.info = ""
        self.itid = 0
        self.type = ""
        self.source = ""
        self.color = ""
    }
}

struct ApiIncome : Decodable {
    var id : Int
    var fkIncomeType : Int
    var date: String   //must be Date
    var value : Double
    var name : String
    var info : String
    
    init(){
        self.id = 0
        self.fkIncomeType = 0
        self.date = ""
        self.value = 0.0
        self.name = ""
        self.info = ""
    }
}
