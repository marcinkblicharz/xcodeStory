//
//  RestCostTypes.swift
//  story
//
//  Created by Marcin Blicharz on 27/04/2023.
//

import Foundation

class RestCostTypes : ObservableObject {
    
    private var dataTask : URLSessionDataTask?
    @Published var actl : [ApiCostTypes] = []
    @Published var act : ApiCostTypes = ApiCostTypes()
    
    func getCostTypes(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.actl = try JSONDecoder().decode([ApiCostTypes].self, from: data!)
                } catch {
                    print("error get data from api")
                }
                
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
    func getCostType(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.act = try JSONDecoder().decode(ApiCostTypes.self, from: data!)
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

struct ApiCostTypes : Decodable {
    var id : Int
    var type : String
    var subtype : String
    var color : String
    
    init(){
        self.id = 0
        self.type = ""
        self.subtype = ""
        self.color = ""
    }
}