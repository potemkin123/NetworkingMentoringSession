//
//  EpisodesPresenter.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 08.04.2023.
//

import Foundation

protocol EpisodesView: AnyObject {
    func display(_ episode: [Episode])
    func display(isLoading: Bool)
}

class EpisodesPresenter {
    
    weak var view: EpisodesView?
    var podcast: Podcast?
    var episode: Episode?
    var selectedEpisode: Episode?
    
    func onRefresh() {
        guard let podcast = podcast else { return }
        view?.display(isLoading: true)
        let link = "https://listen-api-test.listennotes.com/api/v2/podcasts"
        let url = URL(string: link)!.appending(component: podcast.id)
        var request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(EpisodesResult.self, from: data)
               
                DispatchQueue.main.async {
                    self.view?.display(result.episodes)
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
