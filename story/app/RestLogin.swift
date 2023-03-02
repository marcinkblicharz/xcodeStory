//
//  RestLogin.swift
//  story
//
//  Created by Marcin Blicharz on 02/03/2023.
//

import Foundation

class RestLogin : ObservableObject {
    
    @Published var vm_logins : [ApiUser] = []
    
    func getLogins(urlLink : String){
        
        guard let url = URL(string: urlLink) else {
            return
        }
        
        print("vm_users (initial) size is: " + String(vm_logins.count))
        
        let task = URLSession.shared.dataTask(with : url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let users = try JSONDecoder().decode([ApiUser].self, from: data)
                DispatchQueue.main.async {
                    self?.vm_logins = users
                }

            } catch {
                print(error)
            }
        }
        
        print("vm_logins (final) size is: " + String(vm_logins.count))
        
        task.resume()
    }
}

struct ApiUser : Hashable, Codable {
    var id : Int?
    var name: String?
    var password : String?
    var cost : String?
    var cost_type : String?
    var income : String?
    var income_type : String?
}
