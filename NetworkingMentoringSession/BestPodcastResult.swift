//
//  BestPodcastResult.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 29.03.2023.
//

import Foundation
struct bestPodcastResult: Decodable {
    let podcasts: [Podcast]
}

struct Podcast: Decodable {
    let id: String
    let title: String
}













    
    //    let type: String
    //    let email: String
    //        case id
    //        case name
    //        case total
    //        case parentID = "parent_id"
    //        case hasNext = "has_next"
    //        case padeNumber = "page_number"
    //        case hasPrevious = "has_previous"
    //        case nextPageNumber = "next_page_number"
    //        case previousPageNumber = "previous_page_number"
