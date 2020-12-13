//
//  FriendRequestCell.swift
//  facebookFeed
//
//  Created by LeeChan on 11/6/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Name"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let requestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.blue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: UIControl.State())
        button.setTitleColor(UIColor.white, for:  UIControl.State())
        button.backgroundColor = UIColor.rgb(red: 87, green: 143, blue: 255)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: UIControl.State())
        button.setTitleColor(UIColor(white: 0.3, alpha: 1), for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSelf()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension FriendRequestCell {
    func configureSelf() {
        
    }
    
    func configureSubviews() {
        addSubview(requestImageView)
        addSubview(nameLabel)
        addSubview(confirmButton)
        addSubview(deleteButton)
        
        addConstraintsWithFormat("H:|-16-[v0(52)]-8-[v1]|", views: requestImageView, nameLabel)
        addConstraintsWithFormat("V:|-4-[v0]-4-|", views: requestImageView)
        addConstraintsWithFormat("V:|-4-[v0]-8-[v1(24)]-8-|", views: nameLabel, confirmButton)
        
        addConstraintsWithFormat("H:|-76-[v0(80)]-8-[v1(80)]", views: confirmButton, deleteButton)
        addConstraintsWithFormat("V:[v0(24)]-8-|", views: deleteButton)
    }
}

extension FriendRequestCell {
    func populate(with indexPath: IndexPath) {
        switch (indexPath.row % 3) {
        case 0:
            nameLabel.text = "Mark Zuckerberg"
            requestImageView.image = UIImage(named: "zuckprofile")
        case 1:
            nameLabel.text = "Steve Jobs"
            requestImageView.image = UIImage(named: "steve_profile")
        default:
            nameLabel.text = "Mahatma Gandhi"
            requestImageView.image = UIImage(named: "gandhi_profile")
        }
        imageView?.backgroundColor = UIColor.black
    }
}

extension FriendRequestCell: Reusable {}
