//
//  HomeController.swift
//  KantoTest
//
//  Created by Alejandro Ferreira on 2021-02-26.
//

import Foundation
import Alamofire


class HomeController {
    private let sourcesURLUser = URL(string: "https://run.mocky.io/v3/4efa83dd-6ff7-4bc1-9c17-3a45016978a7")!
    private let sourcesURLGrabacionesList = URL(string: "https://run.mocky.io/v3/2f188654-7f58-4267-8887-ede536d8382e")!
    var userData: User?
    var grabacionesList: [GrabacionesList]?
    
    
    func getUserData(completion : @escaping (User) -> ()){
        AF.request(sourcesURLUser, method: .get).responseJSON { response in
            print(response)
            // result of response serialization
            if let responseData = response.data {
                do {
                    let decodeJson = JSONDecoder()
                    self.userData = try decodeJson.decode(User.self, from: responseData)
                    DispatchQueue.main.async() {
                        completion(self.userData!)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        

        
    }
    
    
    func getGrabacionesList(completion : @escaping ([GrabacionesList]) -> ()){
        AF.request(sourcesURLGrabacionesList, method: .get).responseJSON { response in
            print(response)
            // result of response serialization
            if let responseData = response.data {
                do {
                    let decodeJson = JSONDecoder()
                    self.grabacionesList = try decodeJson.decode([GrabacionesList].self, from: responseData)
                    DispatchQueue.main.async() {
                        completion(self.grabacionesList!)
                    }

                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }


    
    
}
