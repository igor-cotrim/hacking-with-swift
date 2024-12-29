//
//  PetitionModel.swift
//  05-WhitehousePetitions
//
//  Created by Igor Cotrim on 27/12/24.
//

import Foundation

struct PetitionModel: Decodable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct PetitionsResult: Decodable {
    var results: [PetitionModel]
}
