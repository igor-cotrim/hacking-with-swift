//
//  InstafilterViewController.swift
//  09-Instafilter
//
//  Created by Igor Cotrim on 13/01/25.
//

import UIKit
import CoreImage
import Combine

class InstafilterViewController: UIViewController {
    // MARK: - UI Components
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var radius: UISlider!
    
    // MARK: - Properties
    private let viewModel = InstafilterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    // MARK: - Private Methods
    private func setupUI() {
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(importPicture)
        )
    }
    
    private func setupBindings() {
        viewModel.$intensityValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.intensity.value = value
            }
            .store(in: &cancellables)
        
        viewModel.$radiusValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.radius.value = value
            }
            .store(in: &cancellables)
        viewModel.$screenTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.title = title
            }
            .store(in: &cancellables)
        viewModel.$processedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showAlert(title: "Error", message: message)
            }
            .store(in: &cancellables)
        
        viewModel.$successMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showAlert(title: "Success", message: message)
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        
        viewModel.getAvailableFilters().forEach { filter in
            alert.addAction(UIAlertAction(title: filter.name, style: .default) { [weak self] _ in
                self?.viewModel.setFilter(filter.name)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        viewModel.saveImage()
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        viewModel.updateIntensity(sender.value)
    }
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        viewModel.updateRadius(sender.value)
    }
}

// MARK: - UIImagePickerController Delegate
extension InstafilterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        viewModel.setImage(image)
    }
}
