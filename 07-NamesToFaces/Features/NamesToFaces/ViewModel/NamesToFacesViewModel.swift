//
//  NamesToFacesViewModel.swift
//  07-NamesToFaces
//
//  Created by Igor Cotrim on 07/01/25.
//

import UIKit

class NamesToFacesViewModel {
    // MARK: - Properties
    private var people: [Person] = []
    private let imageService: ImageServiceProtocol
    
    // MARK: - Callbacks
    var onPeopleUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initialization
    init(imageService: ImageServiceProtocol = ImageService()) {
        self.imageService = imageService
    }
    
    // MARK: - Public Methods
    var numberOfPeople: Int {
        return people.count
    }
    
    func person(at index: Int) -> Person {
        return people[index]
    }
    
    func loadImage(for person: Person) -> UIImage? {
        return imageService.loadImage(named: person.image)
    }
    
    func addPerson(with image: UIImage) {
        guard let imageName = imageService.saveImage(image, withQuality: 0.8) else {
            onError?("Failed to save image")
            return
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        onPeopleUpdated?()
    }
    
    func updatePersonName(at index: Int, with newName: String) {
        guard index < people.count else { return }
        people[index].name = newName
        onPeopleUpdated?()
    }
}
