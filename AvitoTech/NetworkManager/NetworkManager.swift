//
//  NetworkManager.swift
//  AvitoTech
//
//  Created by timur on 20.10.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func getEmployeesList(completion: @escaping (ObtainResult) -> Void )
}

class NetworkManager: NetworkManagerProtocol {
    
    func getEmployeesList(completion: @escaping (ObtainResult) -> Void) {
        
        guard let url = URL(string: API.getEmployeesList) else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            var result: ObtainResult = .success(employee: [])
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300
            else {
                print(error?.localizedDescription as Any)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let avito = try decoder.decode(Avito.self, from: data)
                completion(.success(employee: avito.company.employees))
            } catch {
                completion(.failure(error: error))
            }
        }
        task.resume()
    }
}
