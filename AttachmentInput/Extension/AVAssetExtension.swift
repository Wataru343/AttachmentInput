//
//  AVAssetExtension.swift
//  AttachmentInput
//
//  Created by Admin on 10/7/20.
//  Copyright © 2020 cybozu. All rights reserved.
//

import AVKit

extension AVAsset {

    func generateThumbnail(completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image).jpegData(compressionQuality: 0.3) as Data?)
                } else {
                    completion(nil)
                }
            })
        }
    }
}
