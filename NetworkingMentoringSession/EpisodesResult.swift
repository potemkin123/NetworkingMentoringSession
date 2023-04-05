//
//  EpisodesResult.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 03.04.2023.
//
#warning("SHOULD HAVE SPACE between imports and definitions")
#warning("MODELS should be in different files")
import Foundation
struct EpisodesResult: Decodable {
    let episodes: [Episode]
}

struct Episode: Decodable {
    let id: String
    let title: String
}
