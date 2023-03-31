//
//  RestCosts.swift
//  story
//
//  Created by Marcin Blicharz on 11/03/2023.
//

import Foundation

class RestCosts : ObservableObject {
    
    @Published var vm_costs : [ApiCosts] = []
    @Published var vm_costss : [ApiCosts] = []
    private var dataTask : URLSessionDataTask?
    @Published var acl : [ApiCosts] = []
    
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
        
        print("vm_costs (initial) size is: " + String(vm_costs.count) + " for link: " + urlLink)
        
        let task = URLSession.shared.dataTask(with : url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let costs = try JSONDecoder().decode([ApiCosts].self, from: data)
                DispatchQueue.main.async {
                    self?.vm_costs = costs
                    print(costs)
                }

            } catch {
                print(error)
            }
        }
        
        print("vm_costs (final) size is: " + String(vm_costs.count))
        
        task.resume()
    }
    
//    func getLastCosts(urlLink : String, completion: @escaping (Result<ApiCostsData, Error>) -> Void){
    func getLastCosts(urlLink : String, completion: @escaping (Result<[ApiCosts], Error>) -> Void){
     
        print("getLastCosts is Started! " + urlLink)
        
        guard let url = URL(string: urlLink) else {
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: " + error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Empty response")
                return
            }
            print("Response status code: " + String(response.statusCode))
            
            guard let data = data else {
                print("Empty data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
//                let jsonData = try decoder.decode(ApiCostsData.self, from: data)
//                let jsonData = try decoder.decode([ApiCosts].self, from: data)
//
//                DispatchQueue.main.async {
////                    self.vm_costss = jsonData
//                    completion(.success(jsonData))
//                    print("vm_costs size01: " + String(self.vm_costs.count))
////                    for x in jsonData{
////                        self.vm_costs.append(x)
//////                        ApiCosts(apicosts: x)
////                    }
////                    dump(self.vm_costs)
//                }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                    return
                }
                print(json)
//                self.vm_costs = json
                print("vm_costs size02: " + String(self.vm_costs.count))
            } catch let error {
                completion(.failure(error))
            }
        }
//        print("vm_costss size03: " + String(self.vm_costss.count))
        print("vm_costs size03: " + String(self.vm_costs.count))
        dataTask?.resume()
    }
    
    func getCostsInner(urlLink : String, completed: @escaping () -> ()){
        
        let url = URL(string: urlLink)
        
        URLSession.shared.dataTask(with : url!) { data, response, error in
            if error == nil {
                do {
                    self.acl = try JSONDecoder().decode([ApiCosts].self, from: data!)
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


//struct ApiCostsData : Encodable, Decodable {
//    var costs : [ApiCosts]
//
//    private enum CodingKeys: String, CodingKey {
//        case costs = "results"
//    }
//}

struct ApiCosts : Decodable {
    var cid : Int
    var date: String   //must be Date
    var value : Double
    var name : String
    var info : String
    var ctid : Int
    var type : String
    var subtype : String
    var color : String
    
//    private enum CodingKeys: String, CodingKey {
//        case cid = "id"
//    }
}
