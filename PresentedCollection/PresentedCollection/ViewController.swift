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
@objc fileprivate protocol CloseViewDelegate: class {
    @objc optional func closeViewDidTap(view: CloseView)
}
fileprivate class CloseView: UIView {
    
    weak var delegate: CloseViewDelegate?
    let lineWidth: CGFloat = 2.0
    let lineColor: UIColor = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        beginCloseView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginCloseView() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CloseView.didTap(gesture:)))
        addGestureRecognizer(singleTap)
    }
    
    func didTap(gesture: UITapGestureRecognizer) {
        delegate?.closeViewDidTap?(view: self)
    }
    
    override func draw(_ rect: CGRect) {
        func p(x: CGFloat, y: CGFloat) -> CGPoint { return CGPoint(x: x * rect.width, y: y * rect.height) }
        func px(x: CGFloat) -> CGFloat { return x * rect.width }
        func py(y: CGFloat) -> CGFloat { return y * rect.height }
        
        let ctx = UIGraphicsGetCurrentContext()!
        UIColor.clear.setFill()
        lineColor.setStroke()
        
        let q: CGFloat = 0.25
        let bp = UIBezierPath()
        bp.lineWidth = lineWidth
        bp.lineCapStyle = CGLineCap.round
        bp.move(to: p(x: q, y: q))
        bp.addLine(to: p(x: (1 - q), y: (1 - q)))
        bp.stroke()
        
        ctx.translateBy(x: rect.width/2, y: rect.height/2)
        ctx.rotate(by: CGFloat(M_PI)/2)
        ctx.translateBy(x: -rect.width/2, y: -rect.height/2)
        bp.stroke()
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
    
    let arrTest = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thusday", "Friday", "Saturday", "April", "August", "December", "January", "July", "June", "November"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CLCollection"
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    func addTextAt(index: Int) {
        titleLabel.text = arrTest[index]
        descriptionLabel.text = "Description: " + arrTest[index]
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
            
            let screen = UIScreen.main.bounds
            let closeView = CloseView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
            closeView.isOpaque = false
            closeView.delegate = self
            titleLabel = UILabel(frame: CGRect(x: 10, y: screen.height - 60, width: screen.width - 10 * 2, height: 20))
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            descriptionLabel = UILabel(frame: CGRect(x: 10, y: screen.height - 34, width: screen.width - 10 * 2, height: 20))
            descriptionLabel.textColor = UIColor.white
            descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            
            collection = CLCollection()
            collection.senderView = cell.imageView
            collection.dataSource = self
            collection.delegate = self
            collection.initialIndex = indexPath.row
            collection.decoratorView = [closeView, titleLabel, descriptionLabel]
            addTextAt(index: indexPath.row)
            
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
            addTextAt(index: indexPath.row)
        }
    }
}

extension ViewController: CloseViewDelegate {
    fileprivate func closeViewDidTap(view: CloseView) {
        collection.dismiss()
    }
}

