//
//  ViewController.swift
//  TweetsCombine
//
//  Created by Alliston Aleixo on 14/10/21.
//

import UIKit
import SDWebImage //loading image url
import LBTATools //stack easy layout
import Combine

class ViewController: UITableViewController {
    let twitterViewModel = TwitterViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBarListeners()
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search Tweets"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    fileprivate func setupSearchBarListeners() {
        // 1. data stream form UITextField to bind property in view model
        let publisher = NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification,
                          object: searchController.searchBar.searchTextField)
        
        publisher.compactMap {
            ($0.object as? UISearchTextField)?.text
        }
        .sink { [unowned self] (str) in
            self.twitterViewModel.searchText.send(str)
        }.store(in: &subscriptions)
            
        // 2. update UITableView whenever tweets are updated
        twitterViewModel.tweets.sink { [unowned self] (_) in
            self.tableView.reloadData()
        }.store(in: &subscriptions)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twitterViewModel.tweets.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TweetCell(style: .subtitle, reuseIdentifier: nil)
        let tweet = twitterViewModel.tweets.value[indexPath.row]
        
        let url = tweet.user.profileImageUrl.replacingOccurrences(of: "http", with: "https")
        
        cell.tweetTextLabel.text = tweet.text
        cell.nameLabel.text = tweet.user.name
        cell.profileImageView.sd_setImage(with: URL(string: url))
        return cell
    }
}

