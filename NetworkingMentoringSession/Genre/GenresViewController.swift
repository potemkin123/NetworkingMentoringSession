//
//  ViewController.swift
//  NetworkingMentoringSession
//
//  Created by Владислав Юрченко on 24.03.2023.
//

import UIKit

final class GenresViewController: UITableViewController {
    let presenter = GenresPresenter()
    var models: [Genre] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        tableView.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        onRefresh()
    }
    
    @objc
    func onRefresh() {
        presenter.onRefresh()
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let podcast = storyboard.instantiateViewController(withIdentifier: String(describing: PodcastsViewController.self)) as! PodcastsViewController
        podcast.presenter.genre = models[indexPath.row]
        navigationController?.pushViewController(podcast, animated: true)
    }
}

extension GenresViewController: GenresView {
    func display(_ genres: [Genre]) {
        models = genres
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
