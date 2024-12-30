//
//  WhitehousePetitionsViewController.swift
//  05-WhitehousePetitions
//
//  Created by Igor Cotrim on 27/12/24.
//

import UIKit

class WhitehousePetitionsViewController: UITableViewController {
    private let viewModel = WhitehousePetitionsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBindings()
        viewModel.loadPetitions()
    }
    
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetList))
        
        navigationItem.leftBarButtonItems = [filterButton, resetButton]
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Credits",
            style: .plain,
            target: self,
            action: #selector(showCredits)
        )
    }
    
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: WhitehousePetitionsConstants.errorTitle,
            message: message,
            preferredStyle: .alert
        )
        alert
            .addAction(
                UIAlertAction(
                    title: WhitehousePetitionsConstants.buttonOk,
                    style: .default
                )
            )
        present(alert, animated: true)
    }
    
    @objc private func filterPetitions() {
        let alert = UIAlertController(
            title: WhitehousePetitionsConstants.filterTitle,
            message: WhitehousePetitionsConstants.filterMessage,
            preferredStyle: .alert
        )
        alert.addTextField()
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak alert] _ in
            guard let filterWord = alert?.textFields?[0].text else { return }
            self?.viewModel.showFilteredPetitions(for: filterWord)
        }
        
        alert.addAction(filterAction)
        present(alert, animated: true)
    }
    
    @objc private func resetList() {
        viewModel.filteredPetitions = viewModel.petitions
        viewModel.onUpdate?()
    }
    
    @objc private func showCredits() {
        let alert = UIAlertController(
            title: WhitehousePetitionsConstants.creditsTitle,
            message: WhitehousePetitionsConstants.creditsMessage,
            preferredStyle: .alert
        )
        alert
            .addAction(
                UIAlertAction(
                    title: WhitehousePetitionsConstants.buttonOk,
                    style: .default
                )
            )
        present(alert, animated: true)
    }
}

// MARK: - TableView
extension WhitehousePetitionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhitehousePetitionsCell", for: indexPath)
        let petition = viewModel.filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PetitionsDetailViewController()
        viewController.detailItem = viewModel.filteredPetitions[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
