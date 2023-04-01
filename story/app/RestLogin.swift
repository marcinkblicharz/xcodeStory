//
//  RestLogin.swift
//  story
//
//  Created by Marcin Blicharz on 02/03/2023.
//

import Foundation

class RestLogin : ObservableObject {
    
    @Published var vm_logins : [ApiUser] = []
    @Published var vm_login : ApiUser = ApiUser()
    @Published var error : Bool = true
    
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
    
    func getLogin(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.vm_login = try JSONDecoder().decode(ApiUser.self, from: data!)
                    self.error = false
                } catch {
                    print("error get data from api")
                    self.error = true
                }
                DispatchQueue.main.async {
                    completed()
                }
            } else {
                self.error = true
            }
        }.resume()
    }
}

struct ApiUser : Hashable, Codable {
    var id : Int
    var name: String
    var password : String
    var cost : String
    var cost_type : String
    var income : String
    var income_type : String
    
    init() {
        self.id = 0
        self.name = ""
        self.password = ""
        self.cost = ""
        self.cost_type = ""
        self.income = ""
        self.income_type = ""
    }
}
