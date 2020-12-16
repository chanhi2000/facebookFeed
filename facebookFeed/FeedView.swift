//
//  FeedView.swift
//  facebookFeed
//
//  Created by LeeChan on 12/13/20.
//  Copyright © 2020 MarkiiimarK. All rights reserved.
//

import UIKit
import SnapKit

protocol FeedViewDelegate : AnyObject {
    func didTapImageView(for image:UIImage)
}

class FeedView: UIView {
    weak var delegate: FeedViewDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemBackground
        cv.alwaysBounceVertical = true
        cv.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        return cv
    }()
    
    private lazy var blackBackgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.alpha = 0
        return v
    }()
    
    private lazy var zoomedImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateZoomOut)))
        return iv
    }()
    
    private var statusImageView = UIImageView()
    private let tabBarCoverView = UIView()
    
    private lazy var navBarCoverView : UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 1000, height: 20+44)
        v.backgroundColor = .black
        v.alpha = 0
        return v
    }()
    
    
    init() {
        super.init(frame: .zero)
        configureSelf()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}

private extension FeedView {
    func configureSelf() {
        backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    func configureSubviews() {
        addSubviews(collectionView,
                    zoomedImageView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension FeedView {
    func connectCollectionViewDelegate(with target: UICollectionViewDelegate?) {
        collectionView.delegate = target
    }
    
    func bindCollectionView(to manager: FeedCollectionViewManager) {
        manager.manage(collectionView)
    }
    
    private func configureStatusImageView(with imageView: UIImageView) {
        addSubview(blackBackgroundView)
        blackBackgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        statusImageView = imageView
        statusImageView.alpha = 0
    }
    
    private func configureZoomedImageView(at frame :CGRect) {
        zoomedImageView.frame = frame
        zoomedImageView.image = statusImageView.image
        addSubview(zoomedImageView)
    }
    
    func animateZoomIn(for imageView: UIImageView) {
        // hide the original image
        configureStatusImageView(with: imageView)
        guard let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) else { return }
        configureZoomedImageView(at: startingFrame)
        
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(navBarCoverView)
            tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
            tabBarCoverView.backgroundColor = .black
            tabBarCoverView.alpha = 0
            keyWindow.addSubview(tabBarCoverView)
        }

        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut, animations: {
                        let height = (self.frame.width / startingFrame.width) * startingFrame.height
                        let y = self.frame.height / 2 - height / 2
                        self.zoomedImageView.frame = CGRect(x: 0, y: y, width: self.frame.width, height: height)
                        self.blackBackgroundView.alpha = 1
                        self.navBarCoverView.alpha = 1
                        self.tabBarCoverView.alpha = 1
            }, completion: nil)
    }
    
    @objc
    func animateZoomOut() {
        guard let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) else {return}
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut, animations: {
                self.zoomedImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
            }, completion: { (didComplete) in
                self.zoomedImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCoverView.removeFromSuperview()
                self.statusImageView.alpha = 1
        })
    }
    
    func reload() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
