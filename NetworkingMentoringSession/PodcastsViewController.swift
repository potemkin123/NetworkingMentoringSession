//
//  PodcastsViewController.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 29.03.2023.
//

import UIKit


class PodcastsViewController: UITableViewController {
    var styles: [Podcast] = []
    var genre: Genre?
    var selectedPodcast: Podcast?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(getbestPodcast), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        getbestPodcast()
        print("ViewDidLoad")
        print (genre)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        print(segue.destination)
        if segue.identifier == "bestEpisodes", let vc = segue.destination as? EpisodesViewController {
            vc.podcast = selectedPodcast
        }
    }
    
    @objc
    func getbestPodcast() {
        guard let genre = genre else {return}
        
        var components = URLComponents(string: "https://listen-api-test.listennotes.com/api/v2/best_podcasts")!
        components.queryItems = [
            URLQueryItem(name: "genre_id", value: String(genre.id))
        ]
        let request = URLRequest(url: components.url!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {return}
            
            do {
                let result = try JSONDecoder().decode(bestPodcastResult.self, from: data)
                print("DECODING RESULT \(result)")
                self.styles = result.podcasts
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView?.refreshControl?.endRefreshing()
                }
                
            } catch {
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
        return styles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        let podcast = styles[indexPath.row]
        cell.textLabel?.text = podcast.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let podcast = styles[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPodcast = styles[indexPath.row]
        self.performSegue(withIdentifier: "bestEpisodes", sender: self)
    }
}

