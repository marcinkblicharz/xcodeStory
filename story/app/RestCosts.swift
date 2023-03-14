//
//  RestCosts.swift
//  story
//
//  Created by Marcin Blicharz on 11/03/2023.
//

import Foundation

let dateFormatterDay = DateFormatter()
dateFormatterDay.dateFormat = "YYYY-MM-dd"

class RestCosts : ObservableObject {
    
    @Published var vm_costs : [ApiCosts] = []
    
    func getCosts(urlLink : String){
        
        guard let url = URL(string: urlLink) else {
            return
        }
        
        print("vm_costs (initial) size is: " + String(vm_costs.count))
        
        let task = URLSession.shared.dataTask(with : url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let costs = try JSONDecoder().decode([ApiCosts].self, from: data)
                DispatchQueue.main.async {
                    self?.vm_costs = costs
                }

            } catch {
                print(error)
            }
        }
        
        print("vm_costs (final) size is: " + String(vm_costs.count))
        
        task.resume()
    }
}

struct ApiCosts : Hashable, Codable {
    var cid : Int?
    var date: Date.fo?
    var value : Double?
    var name : String?
    var info : String?
    var ctid : Int?
    var type : String?
    var subtype : String?
    var color : String?
}
