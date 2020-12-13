//
//  FriendRequestView.swift
//  facebookFeed
//
//  Created by LeeChan on 12/13/20.
//  Copyright © 2020 MarkiiimarK. All rights reserved.
//

import UIKit

class FriendRequestsView : UIView {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.rgb(red: 229, green: 231, blue: 235)
        tv.sectionHeaderHeight = 26
        tv.register(FriendRequestCell.self, forCellReuseIdentifier: FriendRequestCell.reuseIdentifier)
        tv.register(FriendRequestHeaderView.self, forHeaderFooterViewReuseIdentifier: FriendRequestHeaderView.reuseIdentifier)
        return tv
    }()
    
    init() {
        super.init(frame: .zero)
        configureSelf()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FriendRequestsView {
    func configureSelf() {
        
    }
    
    func configureSubviews() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension FriendRequestsView {
    func bindTableView<Manager: UITableViewDataSource & UITableViewDelegate>(to manager: Manager) {
        tableView.dataSource = manager
        tableView.delegate = manager
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
