//
//  HomeVC.swift
//  AvitoTech
//
//  Created by timur on 20.10.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var viewModel: HomeViewModelProtocol!
    var dataSource: [Employee] = []

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        viewModel = HomeViewModel()
        super.viewDidLoad()
        showAlert()
        isCheckedInternet()
    }

    func fetchData() {
        viewModel.fetchData { [weak self] in
            guard let self = self else { return }
            self.dataSource = self.viewModel.employees
            self.tableView.reloadData()
        }
    }
    
    func isCheckedInternet() {
            if NetworkMonitor.shared.isConnected {
                fetchData()
            } else {
                
                viewModel.deleteSavedEmployees()
            }
        }
    
    func showAlert() {
        let alert = UIAlertController(title: "Connection problems!!", message: "you don't have internet connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reconnect", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewDidLoad()
        }))
        alert.addAction(UIAlertAction(title: "Offline", style: .cancel))

        present(alert, animated: true)
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NetworkMonitor.shared.isConnected {
            return dataSource.count
        } else {
            return viewModel.getSavedEmployees().count
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigCell", for: indexPath) as! ConfigCell
        
        if NetworkMonitor.shared.isConnected {
            
            let post = viewModel.arraySorting(data: dataSource) [indexPath.row]
            
            cell.nameLabel.text = post.name
            cell.phoneNumberLabel.text = post.phoneNumber
            cell.skillsLabel.text = post.skills.joined(separator: " ")
            
        } else {
            
            let post = viewModel.arraySorting(data: viewModel.getSavedEmployees()) [indexPath.row]
            
            cell.nameLabel.text = post.name
            cell.phoneNumberLabel.text = post.phoneNumber
            cell.skillsLabel.text = post.skills.joined(separator: " ")
        }

        return cell
    }
}
