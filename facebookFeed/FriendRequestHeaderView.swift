//
//  FriendRequestHeaderView.swift
//  facebookFeed
//
//  Created by LeeChan on 12/13/20.
//  Copyright © 2020 MarkiiimarK. All rights reserved.
//

import UIKit

class FriendRequestHeaderView: UITableViewHeaderFooterView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "FRIEND REQUESTS"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        return label
    }()
    
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235)
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureSelf()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension FriendRequestHeaderView {
    func configureSelf() {

    }
    
    func configureSubviews() {
        addSubview(nameLabel)
        addSubview(bottomBorderView)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: nameLabel)
        addConstraintsWithFormat("V:|[v0][v1(0.5)]|", views: nameLabel, bottomBorderView)
        addConstraintsWithFormat("H:|[v0]", views: bottomBorderView)
    }
}

extension FriendRequestHeaderView {
    func populate(by section: Int) {
        if section == 0 {   nameLabel.text = "FRIEND REQUESTS"  }
        else { nameLabel.text = "PEOPLE YOU MAY KNOW"   }
    }
}

extension FriendRequestHeaderView: Reusable {}
