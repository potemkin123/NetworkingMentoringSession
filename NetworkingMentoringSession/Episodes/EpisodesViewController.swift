//
//  EpisodesViewController.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 03.04.2023.
//

import UIKit

final class EpisodesViewController: UITableViewController {
    let presenter = EpisodesPresenter()
    var models2: [Episode] = []
    //    var episode: Episode?
    var selectedEpisode: Episode?
    
    override func viewDidLoad() {
        presenter.view = self
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        presenter.episode = selectedEpisode
        onRefresh()
    }
    
    @objc
    func onRefresh() {
        presenter.onRefresh()
        presenter.episode = selectedEpisode
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
}

extension EpisodesViewController: EpisodesView {
    
    func display(_ episode: [Episode]) {
        models2 = episode
        tableView.reloadData()
    }
    
    func display(isLoading: Bool) {
        if isLoading {
            tableView.refreshControl?.beginRefreshing()
        } else {
            tableView.refreshControl?.endRefreshing()
        }
    }
}
