//
//  PodcastsPresenter.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 08.04.2023.
//

import Foundation

protocol PodcastsView: AnyObject {
    func display(_ porcast: [Podcast])
    func display(isLoading: Bool)
}

class PodcastsPresenter {
    
    weak var view: PodcastsView?
    var genre: Genre?
    var selectedPodcast: Podcast?
    
    func onRefresh() {
        guard let genre = genre else { return }
        view?.display(isLoading: true)
        var components = URLComponents(string: "https://listen-api-test.listennotes.com/api/v2/best_podcasts")!
        components.queryItems = [
            URLQueryItem(name: "genre_id", value: String(genre.id))
        ]
        let request = URLRequest(url: components.url!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(BestPodcastResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.view?.display(result.podcasts)
                    self.view?.display(isLoading: false)
                }
            } catch {
                DispatchQueue.main.async {
                    self.view?.display(isLoading: false)
                }
            }
        }
        task.resume()
    }
}
