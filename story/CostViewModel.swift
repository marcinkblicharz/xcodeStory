//
//  CostViewModel.swift
//  story
//
//  Created by Marcin Blicharz on 29/03/2023.
//

import Foundation

class CostViewModel {
    
    private var restCosts = RestCosts()
    private var apiCostList = [ApiCosts]()
    private var link : String =  "" //"http://localhost:8080/rest/getCosts?from=2023-03-13"
    
    func numberOfRowsInSection(section: Int) -> Int {
        if apiCostList.count != 0 {
            return apiCostList.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> ApiCosts {
        return apiCostList[indexPath.row]
    }
}
