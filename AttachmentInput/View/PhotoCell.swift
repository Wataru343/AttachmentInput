//
//  PhotoCell.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/02/14.
//  Copyright © 2018 Cybozu, Inc. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PhotoCell: UICollectionViewCell {
    @IBOutlet private var gradationView: UIView!
    @IBOutlet private var thumbnailView: UIImageView!
    @IBOutlet private var movieIconView: UIImageView!
    @IBOutlet private var checkIconView: UIImageView!
    @IBOutlet private var indicatorView: UIActivityIndicatorView!
    @IBOutlet private var disableView: UIView!

    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        checkIconView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setup(photo: AttachmentInputPhoto, status: AttachmentInputPhotoStatus) {
        self.disposeBag = DisposeBag()
        self.movieIconView.isHidden = !photo.isVideo
        self.gradationView.isHidden = !photo.isVideo
        photo.initializeIfNeed(loadThumbnail: true)
        photo.properties
            .map{!$0.exceededSizeLimit}
            .asDriver(onErrorJustReturn: false)
            .drive(self.disableView.rx.isHidden)
            .disposed(by: self.disposeBag)
        photo.thumbnail
            .map{UIImage(data: $0)}
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(self.thumbnailView.rx.image)
            .disposed(by: self.disposeBag)
        status.output.distinctUntilChanged().map { inputStatus in
            switch inputStatus {
            case .loading:
                return 0.4
            case .selected:
                return 1
            case .unSelected, .compressing, .downloading:
                return 0
            }
        }.bind(to: self.checkIconView.rx.alpha).disposed(by: self.disposeBag)

        status.output.distinctUntilChanged().map { inputStatus in
            switch inputStatus {
            case .compressing, .downloading:
                return true
            default:
                return false
            }
        }.bind(to: self.indicatorView.rx.isAnimating).disposed(by: self.disposeBag)
    }
    
    override func prepareForReuse() {
        // thumbnailView is not updated at the timing of setup, so clear it
        self.thumbnailView.image = nil
    }
}
