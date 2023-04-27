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
}

struct ApiIncome : Decodable {
    var id : Int
    var fkincometype : Int
    var date: String   //must be Date
    var value : Double
    var name : String
    var info : String
    
    init(){
        self.id = 0
        self.fkincometype = 0
        self.date = ""
        self.value = 0.0
        self.name = ""
        self.info = ""
    }
}
