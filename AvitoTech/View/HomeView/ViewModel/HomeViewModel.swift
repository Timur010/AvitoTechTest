//
//  HomeViewModel.swift
//  AvitoTech
//
//  Created by timur on 25.10.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    var employees: [Employee] { get set }
    func fetchData(completion: @escaping () -> Void)
    func getSavedEmployees() -> [Employee]
    func arraySorting(data: [Employee]) -> [Employee]
    func deleteSavedEmployees()
}

class HomeViewModel: HomeViewModelProtocol {
    
    let kay = "dataSource"
    
    var employees: [Employee] = [] {
        didSet {
            saveDate()
        }
    }

    var networkService: NetworkManagerProtocol

    init() {
        networkService = NetworkManager()
    }

    func fetchData(completion: @escaping () -> Void) {
        networkService.getEmployeesList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(employee):
                    self?.employees = employee
                    completion()
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func saveDate() {
        if let encodedData = try? JSONEncoder().encode(employees) {
            UserDefaults.standard.set(encodedData, forKey: kay)
        }
    }
    
    func getSavedEmployees() -> [Employee] {
            guard
                let data = UserDefaults.standard.data(forKey: kay),
                let savedItems = try? JSONDecoder().decode([Employee].self, from: data)
            else {return [Employee(name: "", phoneNumber: "", skills: [""])]}
        
            return savedItems
    }

    func deleteSavedEmployees() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3600.0) {
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    func arraySorting(data: [Employee]) -> [Employee] {
        let arraySorting = data.sorted(by: {(name1, name2) -> Bool in
            let Name = name1.name
            let Name2 = name2.name
            return(Name.localizedCaseInsensitiveCompare(Name2) == .orderedAscending)
        })
        return arraySorting
    }
}
