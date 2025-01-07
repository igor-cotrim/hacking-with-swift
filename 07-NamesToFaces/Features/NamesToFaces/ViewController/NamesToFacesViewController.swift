//
//  NamesToFacesViewController.swift
//  07-NamesToFaces
//
//  Created by Igor Cotrim on 07/01/25.
//

import UIKit

class NamesToFacesViewController: UICollectionViewController {
    // MARK: - Properties
    private let viewModel: NamesToFacesViewModel
    
    // MARK: - Initialization
    init(viewModel: NamesToFacesViewModel = NamesToFacesViewModel()) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = NamesToFacesViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewPerson)
        )
    }
    
    private func setupBindings() {
        viewModel.onPeopleUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

// MARK: - Collection View Data Source & Delegate
extension NamesToFacesViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPeople
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "NamesToFacesPersonCell",
            for: indexPath
        ) as? NamesToFacesCell else {
            fatalError("Unable to dequeue NamesToFacesCell.")
        }
        
        let person = viewModel.person(at: indexPath.item)
        let image = viewModel.loadImage(for: person)
        cell.configure(with: person, image: image)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlertToRenameOrDelete(for: indexPath)
    }
}

// MARK: - Image Picker
extension NamesToFacesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        viewModel.addPerson(with: image)
        dismiss(animated: true)
    }
}

// MARK: - UI Helpers
extension NamesToFacesViewController {
    private func showAlertToRenameOrDelete(for indexPath: IndexPath) {
        let person = viewModel.person(at: indexPath.item)
        let alert = UIAlertController(
            title: "You want to rename \(person.name) or delete it?",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.showRenameAlert(for: indexPath)
        })
        alert.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            self?.viewModel.deletePerson(at: indexPath.item)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showRenameAlert(for indexPath: IndexPath) {
        let person = viewModel.person(at: indexPath.item)
        let alert = UIAlertController(
            title: "Rename person",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.text = person.name == "Unknown" ? "" : person.name
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let newName = alert.textFields?[0].text else { return }
            self?.viewModel.updatePersonName(at: indexPath.item, with: newName)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
