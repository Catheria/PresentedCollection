//
//  ViewController.swift
//  PresentedCollection
//
//  Created by Torpong on 26/01/2017.
//  Copyright © 2017 MailE. All rights reserved.
//

import UIKit
import CLCollection

fileprivate class FBImageCell: UICollectionViewCell {
    
    static let identify = "FBImageCell"
    var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
}


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var listCollections: [UIImage] = {
        return CLImage.allPlaceholderImages
    }()
    var listURLPath: [String] = {
        return CLImage.allImageURLPath
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 140, height: 120)
        let _w: CGFloat = (self.view.bounds.width - (140 * 2))/3
        layout.sectionInset = UIEdgeInsets(top: 0, left: _w, bottom: 0, right: _w)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FBImageCell.self, forCellWithReuseIdentifier: FBImageCell.identify)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    var collection: CLCollection!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CLCollection"
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    // MARK: - CollectionView DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let img = listCollections[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FBImageCell.identify, for: indexPath) as! FBImageCell
        cell.imageView.image = img
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FBImageCell {
             collection = CLCollection()
             collection.senderView = cell.imageView
             collection.dataSource = self
             collection.delegate = self
             collection.initialIndex = indexPath.row
             
             let blackView = UIView()
             blackView.backgroundColor = UIColor.black
             collection.dimmingView = blackView
             collection.present()
        }
    }
}

extension ViewController: CLCollectionDataSource {
    func numberOfViewForCollection(collection: CLCollection) -> Int {
        return listCollections.count
    }
    func collection(collection: CLCollection, imgDefaultAtIndex index: Int) -> UIImage {
        return listCollections[index]
    }
    func collection(collection: CLCollection, urlPathAt index: Int) -> String {
        return listURLPath[index]
    }
}

extension ViewController: CLCollectionDelegate {
    func collectionScrollViewDidEndDecelerating(collection: CLCollection, index: Int) {
        
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: false)
        if let cell = collectionView.cellForItem(at: indexPath) as? FBImageCell {
            collection.senderView = cell.imageView
        }
    }
}
