//
//  ContentController.swift
//  elisoft-test
//
//  Created by Mark G on 09/11/2020.
//

import UIKit

class ContentController: UIViewController {

    fileprivate var _numberOfImages: Int!
    fileprivate(set) var page: Int!
    fileprivate var _itemSize: CGSize {
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
    }
    
    var isFulfill: Bool {
        page * Constant.numberPerPage <= _numberOfImages
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        _setup()
    }


    func configure(page: Int, numberOfImages: Int) {
        self.page = page
        _numberOfImages = numberOfImages
    }
    
    func add() {
        
        // Available when non-fulfill
        guard !isFulfill
        else { return }
        
        _numberOfImages += 1
        let row = _numberOfImages - (page - 1) * Constant.numberPerPage - 1
        let indexPath = IndexPath(row: row, section: 0)
        collectionView.insertItems(at: [indexPath])

    }
}

// MARK: Private
fileprivate extension ContentController {

    func _setup() {
        
        // Layout collection view
        let layout = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        let boardSize = Constant.size
        let spacing = Constant.spacing
        let screenSize = collectionView.bounds.size
        
        // Get width
        let totalHSpacing = boardSize.width * spacing
        let width = (screenSize.width - totalHSpacing) / boardSize.width
        
        // Get height
        let totalVSpacing = (boardSize.height - 1) * spacing
        let height = (screenSize.height - totalVSpacing) / boardSize.height
        
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.itemSize = .init(
            width: width,
            height: height
        )
    }
}

// MARK: Collection View
extension ContentController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard page * Constant.numberPerPage > _numberOfImages else {
            return Constant.numberPerPage
        }
        
        return _numberOfImages - (page - 1) * Constant.numberPerPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(ImageCollectionViewCell.self)",
            for: indexPath
        ) as! ImageCollectionViewCell
        
        let index = indexPath.row + (page - 1) * Constant.numberPerPage
        
        cell.configure(for: index, size: _itemSize)
        
        return cell
    }
}
