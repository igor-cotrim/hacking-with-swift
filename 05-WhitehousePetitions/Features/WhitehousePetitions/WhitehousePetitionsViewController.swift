//
//  WhitehousePetitionsViewController.swift
//  05-WhitehousePetitions
//
//  Created by Igor Cotrim on 27/12/24.
//

import UIKit

class WhitehousePetitionsViewController: UITableViewController {
    var petitions = [PetitionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseJSON(json: data)
                return
            }
        }
        
        showErrorAlert()
    }
    
    private func parseJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(PetitionsResult.self, from: json) {
            petitions = jsonPetitions.results
            
            tableView.reloadData()
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Couldn't load petitions", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TableView
extension WhitehousePetitionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhitehousePetitionsCell", for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let viewController = PetitionsDetailViewController()
        
        viewController.detailItem = petitions[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
