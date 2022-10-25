//
//  ViewController.swift
//  AvitoTech
//
//  Created by timur on 20.10.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tabelView: UITableView!
    
    let networkManager = NetworkManager()
    var dataSource = [employee] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabelView.dataSource = self
        
        networkManager.getEmployeesList { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let employee):
                    self.dataSource = employee
                    self.tabelView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let post = dataSource[indexPath.row ]
        
        cell.name.text = post.name
        cell.phoneNumber.text = post.phoneNumber
        cell.Skills.text = "qwefwrgwe"
        
        return cell
    }
}

