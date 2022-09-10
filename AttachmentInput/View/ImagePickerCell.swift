//
//  ImagePickerCell.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/02/14.
//  Copyright © 2018 Cybozu, Inc. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import AVFoundation
import MobileCoreServices

protocol ImagePickerCellDelegate: class {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    var videoQuality: UIImagePickerController.QualityType { get }
}

class ImagePickerCell: UICollectionViewCell {
    
    @IBOutlet private weak var cameraButton: UIButton!
    private var imagePickerAuthorization = ImagePickerAuthorization()
    private var initialized = false
    private let disposeBag = DisposeBag()
    weak var delegate: ImagePickerCellDelegate?

    @IBAction func tapCamera() {
        if self.imagePickerAuthorization.videoDisableValue {
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        if let videoQuality = self.delegate?.videoQuality {
            picker.videoQuality = videoQuality
        }
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        self.getTopViewController()?.present(picker, animated: true)
    }

    @IBAction func tapPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        if let videoQuality = self.delegate?.videoQuality {
            picker.videoQuality = videoQuality
        }
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        self.getTopViewController()?.present(picker, animated: true)
    }

    private func getTopViewController() -> UIViewController? {
        if var topViewControlelr = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topViewControlelr.presentedViewController {
                topViewControlelr = presentedViewController
            }
            return topViewControlelr
        }
        return nil
    }

    func setup() {
        initializeIfNeed()
    }

    override func awakeFromNib() {
        setupDesign()
    }
    
    private func initializeIfNeed() {
        guard !self.initialized else {
            return
        }
        self.initialized = true
        self.imagePickerAuthorization.checkAuthorizationStatus()
        self.imagePickerAuthorization.videoDisable.subscribe(onNext: { [weak self] disable in
            DispatchQueue.main.async {
                self?.setupDesignForCameraButton(disable: disable)
            }
        }).disposed(by: self.disposeBag)
    }

    private func setupDesign() {
        self.setupDesignForCameraButton(disable: true)
    }
    
    private func setupDesignForCameraButton(disable: Bool) {
        self.cameraButton.isEnabled = !disable
    }
}


extension ImagePickerCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.delegate?.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.imagePickerControllerDidCancel(picker)
    }
}
