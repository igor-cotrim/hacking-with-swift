//
//  InstafilterViewModel.swift
//  09-Instafilter
//
//  Created by Igor Cotrim on 13/01/25.
//

import UIKit
import CoreImage
import Photos
import Combine

class InstafilterViewModel {
    // MARK: - Properties
    private let context: CIContext
    @Published var currentImage: UIImage?
    @Published var processedImage: UIImage?
    @Published var currentFilter: FilterModel?
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var screenTitle: String = "Instafilter"
    @Published var intensityValue: Float = 0.0
    @Published var radiusValue: Float = 0.0
    
    private let availableFilters: [FilterModel] = [
        FilterModel(name: "CISepiaTone", filter: CIFilter(name: "CISepiaTone")!),
        FilterModel(name: "CIBumpDistortion", filter: CIFilter(name: "CIBumpDistortion")!),
        FilterModel(name: "CIGaussianBlur", filter: CIFilter(name: "CIGaussianBlur")!),
        FilterModel(name: "CIPixellate", filter: CIFilter(name: "CIPixellate")!),
        FilterModel(name: "CITwirlDistortion", filter: CIFilter(name: "CITwirlDistortion")!),
        FilterModel(name: "CIUnsharpMask", filter: CIFilter(name: "CIUnsharpMask")!),
        FilterModel(name: "CIVignette", filter: CIFilter(name: "CIVignette")!)
    ]
    
    // MARK: - Initialization
    init() {
        self.context = CIContext()
        self.currentFilter = availableFilters.first
    }
    
    // MARK: - Private Methods
    private func performImageSave(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.successMessage = "Image saved successfully"
                } else {
                    self?.errorMessage = error?.localizedDescription ?? "Error saving image"
                }
            }
        }
    }
    
    private func updateScreenTitle() {
        screenTitle = currentFilter?.name ?? "Instafilter"
    }
    
    private func resetSliderValues() {
        intensityValue = 0.0
        radiusValue = 0.0
    }
    
    private func applyProcessing() {
        guard let currentFilter = currentFilter?.filter,
              let currentImage = currentImage,
              let beginImage = CIImage(image: currentImage) else { return }
        
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensityValue, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radiusValue * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensityValue * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(
                CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2),
                forKey: kCIInputCenterKey
            )
        }
        
        guard let outputImage = currentFilter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        processedImage = UIImage(cgImage: cgImage)
    }
    
    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorMessage = error.localizedDescription
        } else {
            successMessage = "Your image has been saved"
        }
    }
}

extension InstafilterViewModel {
    // MARK: - Public Methods
    func updateIntensity(_ value: Float) {
        intensityValue = value
        applyProcessing()
    }
    
    func updateRadius(_ value: Float) {
        radiusValue = value
        applyProcessing()
    }
    
    func getAvailableFilters() -> [FilterModel] {
        return availableFilters
    }
    
    func setImage(_ image: UIImage) {
        currentImage = image
        updateScreenTitle()
        resetSliderValues()
        applyProcessing()
    }
    
    func setFilter(_ filterName: String) {
        guard let filter = availableFilters.first(where: { $0.name == filterName }) else { return }
        currentFilter = filter
        screenTitle = filterName
        applyProcessing()
    }
    
    func saveImage() {
        guard let processedImage = processedImage else {
            errorMessage = "Please select an image first"
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self?.performImageSave(processedImage)
                case .denied, .restricted:
                    self?.errorMessage = "We need your permission to save your image"
                case .notDetermined:
                    self?.errorMessage = "Please allow us to access your photos"
                @unknown default:
                    self?.errorMessage = "Error when checking permissions."
                }
            }
        }
    }
}
