//
//  WhitehousePetitionsViewModel.swift
//  Swift
//
//  Created by Igor Cotrim on 30/12/24.
//

import Foundation

class WhitehousePetitionsViewModel {
    private let service: PetitionServiceProtocol
    private(set) var petitions: [PetitionModel] = []
    var filteredPetitions: [PetitionModel] = []
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(service: PetitionServiceProtocol = PetitionService()) {
        self.service = service
    }
    
    func loadPetitions() {
        onUpdate?() // Trigger loading state
        service.fetchPetitions() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let petitions):
                    self?.petitions = petitions
                    self?.filteredPetitions = petitions
                    self?.onUpdate?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func showFilteredPetitions(for filter: String) {
        filteredPetitions = petitions.filter { $0.title.localizedCaseInsensitiveContains(filter) }
        onUpdate?()
    }
}
