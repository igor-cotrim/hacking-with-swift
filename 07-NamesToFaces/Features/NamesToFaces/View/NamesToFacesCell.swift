//
//  NamesToFacesCell.swift
//  07-NamesToFaces
//
//  Created by Igor Cotrim on 07/01/25.
//

import UIKit

class NamesToFacesCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func configure(with person: Person, image: UIImage?) {
        name.text = person.name
        imageView.image = image
        
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 3
        layer.cornerRadius = 3
    }
}
