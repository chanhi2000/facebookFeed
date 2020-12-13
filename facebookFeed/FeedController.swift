//
//  ViewController.swift
//  facebookFeed
//
//  Created by LeeChan on 8/21/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import Combine
import UIKit

class FeedController: UIViewController {
    private var token = Set<AnyCancellable>()
    private let collectionViewManager = FeedCollectionViewManager()
    private let networkService = NetworkService()
    private var posts = [Post]()
    private let ui = FeedView()
    
    override func loadView() {
        view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Facebook Feed"
        configureView()
        getPosts()
    }
}

private extension FeedController {
    func configureView() {
        ui.bindCollectionView(to: collectionViewManager)
        ui.connectCollectionViewDelegate(with: self)
        configureManager()
    }
    
    func configureManager() {
        collectionViewManager.cellForRow = { collecionView, indexPath, term in
            guard let cell = collecionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
            cell.populate(with: term)
            cell.feedController = self
            return cell
        }
        
        collectionViewManager.selectedItemPublisher.sink  { [weak self] (indexPath) in
            guard let term = self?.posts[indexPath.item] else { return }
            print(term)
//            self?.navigateToDetails(for: term)
        }.store(in: &token)
    }
    
    func getPosts() {
        NetworkService().getAllPosts { [weak self] (result) in
            switch result {
            case .success(let posts):
                self?.posts = posts
                self?.collectionViewManager.set(posts)
                print(posts)
            case .failure(let error): print(error)
            }
        }
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout {
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
        ui.reload()
    }
}
