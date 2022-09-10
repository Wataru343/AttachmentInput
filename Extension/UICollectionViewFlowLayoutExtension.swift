//
//  UICollectionViewFlowLayoutExtension.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/02/14.
//  Copyright © 2018 Cybozu, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewFlowLayout {
    /// Return recommended cell size for aspect ratio and number of rows
    /// @param aspectRatio (width:height)
    /// @param numberOfRows
    /// @return 1 cell size
    func propotionalScaledSize(aspectRatio: (width: Int, height: Int), numberOfColumns: Int) -> CGSize {
        let width = self.preferredItemWidth(forNumberOfColumns: numberOfColumns)
        let height = CGFloat(aspectRatio.height) / CGFloat(aspectRatio.width) * width
        return CGSize(width: width, height: height)
    }
    /// Returns the recommended height of items for the number of columns
    /// @param forNumberOfRows
    /// @return 1 cell height
    func preferredItemWidth(forNumberOfColumns: Int) -> CGFloat {
        guard forNumberOfColumns > 0 else {
            return 0
        }
        guard let collectionView = self.collectionView else {
            fatalError()
        }
        
        let collectionViewWidth = collectionView.bounds.width
        let inset = self.sectionInset
        let spacing = self.minimumInteritemSpacing
        
        // Evenly divide the width excluding each margin from the width of the collection view
        return (collectionViewWidth - (inset.left + inset.right + spacing * CGFloat(forNumberOfColumns - 1))) / CGFloat(forNumberOfColumns)
    }
}
