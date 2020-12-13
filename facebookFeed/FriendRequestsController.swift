//
//  FriendRequestsController.swift
//  facebookFeed
//
//  Created by LeeChan on 8/30/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import UIKit

class FriendRequestsController: UIViewController {
    
    private let tableViewManager = FeedCollectionViewManager()
    private let ui = FriendRequestsView()
    
    override func loadView() {
        view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Friend Requests"
        configureUI()
    }
}

private extension FriendRequestsController {
    func configureUI() {
        ui.bindTableView(to: self)
    }
}

extension FriendRequestsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestCell.reuseIdentifier, for: indexPath) as? FriendRequestCell else { return UITableViewCell() }
        cell.populate(with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FriendRequestHeaderView.reuseIdentifier) as? FriendRequestHeaderView else { return nil }
        header.populate(by: section)
        return header
    }
}

extension FriendRequestsController: UITableViewDelegate {
}
