//
//  RestIncomeTypes.swift
//  story
//
//  Created by Marcin Blicharz on 27/04/2023.
//

import Foundation

class RestIncomeTypes : ObservableObject {
    
    private var dataTask : URLSessionDataTask?
    @Published var aitl : [ApiIncomeTypes] = []
    @Published var ait : ApiIncomeTypes = ApiIncomeTypes()
    
    func getIncomeTypes(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.aitl = try JSONDecoder().decode([ApiIncomeTypes].self, from: data!)
                } catch {
                    print("error get data from api")
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    func getIncomeType(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.ait = try JSONDecoder().decode(ApiIncomeTypes.self, from: data!)
                } catch {
                    print("error get data from api")
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    func putIncomeType(urlLink : String, jsonSend : [String : Any], completed: @escaping () -> ()){
        
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
    
    func delIncomeType(urlLink : String, completed: @escaping () -> ()){
        
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

struct ApiIncomeTypes : Decodable {
    var id : Int
    var type : String
    var source : String
    var color : String
    
    init(){
        self.id = 0
        self.type = ""
        self.source = ""
        self.color = ""
    }
}

