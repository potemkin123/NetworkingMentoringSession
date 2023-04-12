//
//  Genre.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 05.04.2023.
//

import Foundation

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
