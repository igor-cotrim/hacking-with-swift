//
//  ImageService.swift
//  07-NamesToFaces
//
//  Created by Igor Cotrim on 07/01/25.
//

import UIKit

class ImageService: ImageServiceProtocol {
    func saveImage(_ image: UIImage, withQuality quality: CGFloat) -> String? {
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: quality) {
            try? jpegData.write(to: imagePath)
            return imageName
        }
        return nil
    }
    
    func loadImage(named filename: String) -> UIImage? {
        let path = getDocumentsDirectory().appendingPathComponent(filename)
        return UIImage(contentsOfFile: path.path)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
