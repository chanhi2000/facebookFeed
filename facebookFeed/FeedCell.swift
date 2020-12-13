//
//  FeedCellCollectionViewCell.swift
//  facebookFeed
//
//  Created by LeeChan on 8/25/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import UIKit

private var imageCache = NSCache<AnyObject, AnyObject>()

class FeedCell: BaseCollectionViewCell {
    
    var feedController: FeedController?
    
    @objc
    func animate() {
        feedController?.animateImageView(statusImageView: statusImageView)
    }
    
    var post: Post? {
        didSet {
            
            statusImageView.image = nil
            loader.startAnimating()
            
            if let statusImageUrl = post?.statusImageUrl {
                
                if let image = imageCache.object(forKey: statusImageUrl as AnyObject) as? UIImage {
                    statusImageView.image = image
                    loader.stopAnimating()
                } else {
                    
                    URLSession.shared.dataTask(with: URL(string: statusImageUrl)!, completionHandler: { (data, response, error) -> Void in
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        
                        imageCache.setObject(image!, forKey: statusImageUrl as AnyObject)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.statusImageView.image = image
                            self.loader.stopAnimating()
                        })
                    }).resume()
                }
            }
            
            if let name = post?.name {
                
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
                
                if let city = post?.location?.city, let state = post?.location?.state {
                    
                    let string = "\n\(city), \(state)  •  "
                    let font = UIFont.systemFont(ofSize: 12)
                    let foreground = UIColor.rgb(red: 151, green: 161, blue: 161)
                    attributedText.append(NSAttributedString(string: string, attributes: [
                        NSAttributedString.Key.font: font,
                        NSAttributedString.Key.foregroundColor: foreground
                        ]
                    ))
                    
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
            
            print("name: \(post?.name)")
            print("numLikes: \(post?.numLikes)")
            print("numComments: \(post?.numComments)")
            
            
            if let statusText = post?.statusText {
                statusTextView.text = statusText
            }
            
            if let profileImageName = post?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
            }
            
            if let statusImageName = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImageName)
            }
            
            if let numLikes = post?.numLikes, let numComments = post?.numComments {
                print("passed 4: numLikes = \(numLikes), numComments = \(numComments)")
                likesCommentsLabel.text = "\(numLikes) Likes    \(numComments) Comments"
            }

        }
    }
    
    
    // MARK: - Views & Variables
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2;
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentsLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView();
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
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
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12);
        
        return button;
    }
    
    
    override func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerLineView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
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
    
    let loader = UIActivityIndicatorView(style: .whiteLarge)
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.black
        
        statusImageView.addSubview(loader)
        statusImageView.addConstraintsWithFormat("H:|[v0]|", views: loader)
        statusImageView.addConstraintsWithFormat("V:|[v0]|", views: loader)
    }
    
}
