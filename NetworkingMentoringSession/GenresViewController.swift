//
//  ViewController.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 24.03.2023.
//

import UIKit

#warning("MARK or non inherited classes as `final`")
class GenresViewController: UITableViewController {
    var models: [Genre] = []
    var selectedGenre: Genre?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(getGenres), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        getGenres()
#warning("REMOVE PRINTS")
        print("ViewDidLoad")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
#warning("REMOVE PRINTS")
        print(segue.identifier)
        print(segue.destination)
        if segue.identifier == "bestPodcast", let vc = segue.destination as? PodcastsViewController {
            vc.genre = selectedGenre
        }
    }
    
    @objc
    func getGenres() {
        var request = URLRequest(url: URL(string : "https://listen-api-test.listennotes.com/api/v2/genres")!)
        let session = URLSession(configuration: .default)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {return}
            
            do {
                let result = try JSONDecoder().decode(GenresResult.self, from: data)
#warning("REMOVE PRINTS")
                print("DECODING RESULT \(result)")
                
                self.models = result.genres
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView?.refreshControl?.endRefreshing()
                }
                
            } catch {
#warning("REMOVE PRINTS")
                print("DECODING ERROR \(error)")
                self.tableView?.refreshControl?.endRefreshing()
            }
        }
        
        task.resume()
        tableView.refreshControl?.beginRefreshing()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        let genre = models[indexPath.row]
        cell.textLabel?.text = genre.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGenre = models[indexPath.row]
        self.performSegue(withIdentifier: "bestPodcast", sender: self)
    }
}
