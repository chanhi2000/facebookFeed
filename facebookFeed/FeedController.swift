//
//  ViewController.swift
//  facebookFeed
//
//  Created by LeeChan on 8/21/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import UIKit

let cellId = "cellId"

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "all_posts", ofType: "json") {
            do {
                
                let data = try(NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe))
                
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [String: AnyObject])
                
//                print(jsonDictionary)
                
                if let postsArray = jsonDictionary["posts"] as? [[String: AnyObject]] {
                    
                    for postDictionary in postsArray {
                        let post = Post()
                        post.setValuesForKeys(postDictionary)
                        print(post)
                        posts.append(post)
                    }
                    
                    self.collectionView?.reloadData()
                }
            } catch let err {
                print(err)
            }
        }

        navigationItem.title = "Facebook Feed"
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1);
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    // MARK: - UICollectionViewController
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath.item]
        feedCell.feedController = self
        
        return feedCell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.item].statusText {
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 10)
        }
        return CGSize(width: view.frame.width, height: 500)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // to be sensitive to the orientation of the device and adjust the size of collectionView accordingly
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout();
    }
    
    // MARK: - Animations
    let zoomedImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    var statusImageView: UIImageView?
    
    func animateImageView(statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            // hide the original image
            statusImageView.alpha = 0
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = .black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            if let keyWindow = UIApplication.shared.keyWindow {
                
                navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20+44)
                navBarCoverView.backgroundColor = .black
                navBarCoverView.alpha = 0
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = .black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomedImageView.backgroundColor = .red
            zoomedImageView.frame = startingFrame
            zoomedImageView.isUserInteractionEnabled = true
            zoomedImageView.image = statusImageView.image
            zoomedImageView.contentMode = .scaleAspectFill
            zoomedImageView.clipsToBounds = true
            view.addSubview(zoomedImageView)
            
            zoomedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
                    let height = (self.view.frame.width / startingFrame.width ) * startingFrame.height
                    let y = self.view.frame.height / 2 - height / 2
                    self.zoomedImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                    self.blackBackgroundView.alpha = 1
                    self.navBarCoverView.alpha = 1
                    self.tabBarCoverView.alpha = 1
                }, completion: nil)
        }
    }
    
    @objc
    func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.zoomedImageView.frame = startingFrame
                    self.blackBackgroundView.alpha = 0
                    self.navBarCoverView.alpha = 0
                    self.tabBarCoverView.alpha = 0
                }, completion: { (didComplete) in
                    self.zoomedImageView.removeFromSuperview()
                    self.blackBackgroundView.removeFromSuperview()
                    self.navBarCoverView.removeFromSuperview()
                    self.tabBarCoverView.removeFromSuperview()
                    self.statusImageView?.alpha = 1
            })

        }
    }
}
