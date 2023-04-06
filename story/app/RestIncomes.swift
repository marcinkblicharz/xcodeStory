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
