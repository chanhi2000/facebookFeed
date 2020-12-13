//
//  FeedCellCollectionViewCell.swift
//  facebookFeed
//
//  Created by LeeChan on 8/25/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import UIKit

private var imageCache = NSCache<AnyObject, AnyObject>()

protocol FeedCellDelegate : AnyObject {
    func didTapStatusImageView(for imageView: UIImageView)
}

class FeedCell: UICollectionViewCell {
    
    weak var feedController: FeedController?
    weak var delegate: FeedCellDelegate?
    
    private var post: Post? {
        didSet {
            guard let p = post else { return }
            populateIV(with: p)
            populateLbls(with: p)
        }
    }
    
    
    // MARK: - Views & Variables
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2;
        return lbl
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let statusTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.boldSystemFont(ofSize: 14)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var statusImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        return iv
    }()
    
    let likesCommentsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return lbl
    }()
    
    let dividerLineView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return v
    }()
    
    let likeButton: UIButton = FeedCell.buttonForTitle(" Like", imageName: "like")
    let commentButton: UIButton = FeedCell.buttonForTitle(" Comment", imageName: "comment")
    let shareButton: UIButton = FeedCell.buttonForTitle(" Share", imageName: "share")
    
    // MARK: - Actions
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton();
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(UIColor.rgb(red: 151, green: 161, blue: 171), for: UIControl.State())
        button.setImage(UIImage(named: imageName), for: UIControl.State())
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    func setupStatusImageViewLoader() {
        statusImageView.addSubview(loader)
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.black
        loader.snp.makeConstraints { $0.edges.equalTo(statusImageView) }
//        statusImageView.addConstraintsWithFormat("H:|[v0]|", views: loader)
//        statusImageView.addConstraintsWithFormat("V:|[v0]|", views: loader)
    }
}

private extension FeedCell {
    func configureSelf() {
        backgroundColor = .white
    }
    
    func configureSubviews() {
        addSubviews(nameLabel,
                    profileImageView,
                    statusTextView,
                    statusImageView,
                    likesCommentsLabel,
                    dividerLineView,
                    likeButton,
                    commentButton,
                    shareButton)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        setupStatusImageViewLoader()
        
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat("H:|[v0]|", views: statusImageView)
        addConstraintsWithFormat("H:|-12-[v0]|", views: likesCommentsLabel)
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)
        
        // button constraints
        addConstraintsWithFormat("H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
        addConstraintsWithFormat("V:|-12-[v0]", views: nameLabel)
        addConstraintsWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentsLabel, dividerLineView, likeButton)
        addConstraintsWithFormat("V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat("V:[v0(44)]|", views: shareButton)
    }
    
    func populateIV(with post: Post) {
        statusImageView.image = nil
        loader.startAnimating()
        
        if let statusImageUrl = post.statusImageUrl {
            if let image = imageCache.object(forKey: statusImageUrl as AnyObject) as? UIImage {
                statusImageView.image = image
                loader.stopAnimating()
            } else {
                NetworkService().getImage(with: statusImageUrl) { [weak self] (result) in
                    switch result {
                    case .success(let img):
                        imageCache.setObject(img, forKey: statusImageUrl as AnyObject)
                        self?.statusImageView.image = img
                        self?.loader.stopAnimating()
                    case .failure(let error):   print(error)
                    }
                    
                }
            }
        }
    }
    
    func populateLbls(with post: Post) {
        if let name = post.name {
            let attributedText = NSMutableAttributedString(
                string: name,
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
            )
            
            if let loc = post.location {
                let string = "\n\(loc.city), \(loc.state)  •  "
                let font = UIFont.systemFont(ofSize: 12)
                let foreground = UIColor.rgb(red: 151, green: 161, blue: 161)
                attributedText.append(NSAttributedString(string: string, attributes: [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: foreground
                ]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attributedText.addAttribute(
                    NSAttributedString.Key.paragraphStyle,
                    value: paragraphStyle,
                    range: NSMakeRange(0, attributedText.string.count)
                )
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_small")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributedText.append(NSAttributedString(attachment: attachment))
            }
        
            nameLabel.attributedText = attributedText
        }
        
        print("name: \(post.name)")
        print("numLikes: \(post.numLikes)")
        print("numComments: \(post.numComments)")
        
        if let statusText = post.statusText {
            statusTextView.text = statusText
        }
        
        if let profileImageName = post.profileImageName {
            profileImageView.image = UIImage(named: profileImageName)
        }
        
        if let statusImageName = post.statusImageName {
            statusImageView.image = UIImage(named: statusImageName)
        }
        print("passed 4: numLikes = \(post.numLikes), numComments = \(post.numComments)")
        likesCommentsLabel.text = "\(post.numLikes) Likes    \(post.numComments) Comments"
    }
    
    @objc
    func didTapImageView() {
        delegate?.didTapStatusImageView(for: statusImageView)
    }
}

extension FeedCell {
    func populate(with post: Post) {
        populateIV(with: post)
        populateLbls(with: post)
    }
}

extension FeedCell : Reusable {}
