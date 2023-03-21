//
//  RestCosts.swift
//  story
//
//  Created by Marcin Blicharz on 11/03/2023.
//

import Foundation

class RestCosts : ObservableObject {
    
    @Published var vm_costs : [ApiCosts] = []
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
//        "date": "2023-03-12T23:00:00.000+00:00",
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    func getCosts(urlLink : String){

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
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
    var date: String?   //must be Date
    var value : Double?
    var name : String?
    var info : String?
    var ctid : Int?
    var type : String?
    var subtype : String?
    var color : String?
}
