//
//  InstafilterViewController.swift
//  09-Instafilter
//
//  Created by Igor Cotrim on 13/01/25.
//

import UIKit
import CoreImage

class InstafilterViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var radius: UISlider!
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter! = nil { didSet { title = currentFilter?.name } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(importPicture)
        )
        
        context = CIContext()
//        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentFilter = CIFilter(name: "CISepiaTone")
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Choose Filter",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil, let actionTitle = action.title else {
            return
        }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let image = imageView.image else {
            let alert = UIAlertController(
                title: "Don't have an image",
                message: "Please select one from your library first",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        applyProcessing()
    }
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        applyProcessing()
    }
    
    func applyProcessing() {
        guard let currentFilter else { return }
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter
                .setValue(
                    CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2),
                    forKey: kCIInputCenterKey
                )
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(
            outputImage,
            from: outputImage.extent
        ) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    @objc func image(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved", message: "Your altered image has been saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

