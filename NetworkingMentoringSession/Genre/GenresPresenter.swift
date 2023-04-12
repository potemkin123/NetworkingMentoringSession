//
//  GenresPresenter.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 07.04.2023.
//

import Foundation

protocol GenresView: AnyObject {
    func display(_ genre: [Genre])
    func display(isLoading: Bool)
}

class GenresPresenter {
    
    weak var view: GenresView?
    
    func onRefresh() {
        view?.display(isLoading: true)
        var request = URLRequest(url: URL(string : "https://listen-api-test.listennotes.com/api/v2/genres")!)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(GenresResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.view?.display(result.genres)
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
