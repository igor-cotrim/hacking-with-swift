//
//  NamesToFacesViewModel.swift
//  07-NamesToFaces
//
//  Created by Igor Cotrim on 07/01/25.
//

import UIKit

class NamesToFacesViewModel {
    // MARK: - Properties
    private var people: [Person] = [] {
        didSet {
            onPeopleUpdated?()
        }
    }
    private let imageService: ImageServiceProtocol
    private let storageService: StorageServiceProtocol
    
    // MARK: - Callbacks
    var onPeopleUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initialization
    init(imageService: ImageServiceProtocol = ImageService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.imageService = imageService
        self.storageService = storageService
        
        loadPeople()
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
        savePeople()
        onPeopleUpdated?()
    }
    
    func deletePerson(at index: Int) {
        guard index < people.count else { return }
        people.remove(at: index)
        savePeople()
        onPeopleUpdated?()
    }
    
    func updatePersonName(at index: Int, with newName: String) {
        guard index < people.count else { return }
        people[index].name = newName
        savePeople()
        onPeopleUpdated?()
    }
    
    // MARK: - Private Methods
    private func savePeople() {
        guard let data = try? JSONEncoder().encode(people) else { return }
        storageService.save(data, forKey: StorageService.Keys.people)
    }
    
    private func loadPeople() {
        guard let data = storageService.load(forKey: StorageService.Keys.people) else { return }
        people = (try? JSONDecoder().decode([Person].self, from: data)) ?? []
    }
}
