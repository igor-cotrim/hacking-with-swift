//
//  PetitionServiceProtocol.swift
//  05-WhitehousePetitions
//
//  Created by Igor Cotrim on 30/12/24.
//

import Foundation

protocol PetitionServiceProtocol {
    func fetchPetitions(completion: @escaping (Result<[PetitionModel], Error>) -> Void)
}
