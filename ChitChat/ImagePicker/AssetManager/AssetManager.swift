//
//  AssetManager.swift
//  ChitChat
//
//  Created by ty foskey on 9/15/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import Photos

class AssetManager {
    
    internal let imageManager = PHCachingImageManager()
    typealias PhotoFetchCompletion = ((UIImage) -> Void)

    func fetchPhoto(asset: PHAsset, completion: @escaping(PhotoFetchCompletion)) {
        imageManager.fetch(photo: asset) { (image, isLowResIntermediaryImage) in
            guard isLowResIntermediaryImage == false else { return }
            completion(image)
        }
    }
    
}
