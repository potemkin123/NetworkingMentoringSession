//
//  EpisodesViewController.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 03.04.2023.
//

import UIKit

#warning("NO SPACE between class definition and variables")
class EpisodesViewController: UITableViewController {
    
    var models2: [Episode] = []
    var podcast: Podcast?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(getbestEpisodes), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        getbestEpisodes()
#warning("REMOVE PRINTS")
        print("ViewDidLoad")
        print (podcast)
    }
    
    @objc
    func getbestEpisodes() {
        guard let podcast = podcast else {return}
        
        let link = "https://listen-api-test.listennotes.com/api/v2/podcasts"
        let url = URL(string: link)!.appending(component: podcast.id)
        var request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {return}
            
            do {
                let result = try JSONDecoder().decode(EpisodesResult.self, from: data)
#warning("REMOVE PRINTS")
                print("DECODING RESULT \(result)")
                self.models2 = result.episodes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView?.refreshControl?.endRefreshing()
                }
                
            } catch {
#warning("REMOVE PRINTS")
                print("DECODING ERROR \(error)")
                DispatchQueue.main.async {
                    self.tableView?.refreshControl?.endRefreshing()
                }
            }
        }
        task.resume()
        tableView.refreshControl?.beginRefreshing()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        let episodes = models2[indexPath.row]
        cell.textLabel?.text = episodes.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
#warning("REMOVE unneeded code, episodes not used here, all this method can be removed")
        let episodes = models2[indexPath.row]
    }
}
