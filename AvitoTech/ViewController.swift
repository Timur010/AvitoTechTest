//
//  ViewController.swift
//  AvitoTech
//
//  Created by timur on 20.10.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!

    let networkManager = NetworkManager()
    var dataSource = [employee]()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getEmployeesList { [weak self] result in
            switch result {
            case let .success(employee):
                self?.dataSource = employee
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigCell", for: indexPath) as! ConfigCell

        let post = dataSource[indexPath.row]

        cell.nameLabel.text = post.name
        cell.phoneNumberLabel.text = post.phoneNumber
        cell.skillsLabel.text = post.skills.joined(separator: " ")

        return cell
    }
}
