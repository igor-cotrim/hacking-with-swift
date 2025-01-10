//
//  ImageServiceProtocol.swift
//  07-NamesToFaces
//
//  Created by Igor Cotrim on 07/01/25.
//

import UIKit

protocol ImageServiceProtocol {
    func saveImage(_ image: UIImage, withQuality quality: CGFloat) -> String?
    func loadImage(named: String) -> UIImage?
    func getDocumentsDirectory() -> URL
}
