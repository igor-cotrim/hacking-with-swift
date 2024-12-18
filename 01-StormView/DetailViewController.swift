//
//  DetailViewController.swift
//  01-StormView
//
//  Created by Igor Cotrim on 16/12/24.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var totalOfImages: Int?
    var currentImageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )
        
        if let imageToLoad = selectedImage,
           let totalOfImages = totalOfImages,
           let currentImageIndex = currentImageIndex {
            imageView.image = UIImage(named: imageToLoad)
            title = "Picture \(currentImageIndex) of \(totalOfImages)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc private func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true)
    }
}
