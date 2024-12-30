//
//  PetitionService.swift
//  05-WhitehousePetitions
//
//  Created by Igor Cotrim on 30/12/24.
//

import Foundation

class PetitionService: PetitionServiceProtocol {
    func fetchPetitions(completion: @escaping (Result<[PetitionModel], Error>) -> Void) {
        let urlString = WhitehousePetitionsConstants.apiURL
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let petitionsResult = try decoder.decode(PetitionsResult.self, from: data)
                completion(.success(petitionsResult.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
