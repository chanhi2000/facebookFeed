//
//  CollectionViewManager.swift
//  facebookFeed
//
//  Created by LeeChan on 12/13/20.
//  Copyright © 2020 MarkiiimarK. All rights reserved.
//

import Combine
import UIKit

@available(iOS 13.0, *)
class CollectionViewManager<Section: Hashable, Item: Hashable>: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open var cellForRow: UICollectionViewDiffableDataSource<Section, Item>.CellProvider?
    
    open var selectedItemPublisher = PassthroughSubject<IndexPath, Never>()
    open var willDisplayCellPublisher = PassthroughSubject<(cell: UICollectionViewCell, indexPath: IndexPath), Never>()
    open var cellDisappearedPublisher = PassthroughSubject<(cell: UICollectionViewCell, indexPath: IndexPath), Never>()
    
    private var collectionView: UICollectionView?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    open func manage(_ collectionView: UICollectionView) {
        collectionView.delegate = self

        self.collectionView = collectionView
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] in
            self?.cellForRow?($0, $1, $2)
        }
    }
    
    private func apply(_ change: (inout NSDiffableDataSourceSnapshot<Section, Item>) -> Void) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        change(&snapshot)
        dataSource?.apply(snapshot)
    }
    
    open func set(_ items: [Item], in section: Section) {
        apply {
            $0.appendSections([section])
            $0.appendItems(items)
        }
    }
    
    open func append(_ item: Item, in section: Section) {
        guard var currentSnapshot = dataSource?.snapshot() else { return }
        currentSnapshot.appendItems([item], toSection: section)
        dataSource?.apply(currentSnapshot)
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        willDisplayCellPublisher.send((cell, indexPath))
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        cellDisappearedPublisher.send((cell, indexPath))
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectedItemPublisher.send(indexPath)
    }
}

@available(iOS 13.0, *)
extension CollectionViewManager where Section == SingleSection {
    func set(_ items: [Item]) {
        self.set(items, in: .main)
    }
    
    func append(_ item: Item) {
        self.append(item, in: .main)
    }
}
