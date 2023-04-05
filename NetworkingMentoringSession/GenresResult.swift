//
//  GenresResult.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 29.03.2023.
//

#warning("SHOULD HAVE SPACE between imports and definitions")
#warning("MODELS should be in different files")
import Foundation
struct GenresResult: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
    let parentID: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case parentID = "parent_id"
    }
}
