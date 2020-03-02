//
//  DataCollectionViewCell.swift
//  CoupaGalleryApp
//
//  Created by TJ Hendrickson on 3/1/20.
//  Copyright © 2020 Cole Ramos. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class DataCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!

        private var imageDataTask: URLSessionDataTask?
        
        //The directory we've specified for caching data
        private static var cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "unsplash_archive")

        func downloadPhoto(_ photo: UnsplashPhoto) {
            guard let url = photo.urls[.regular] else { return }
            
            //If the image is alredy cached
            if let cachedResponse = DataCollectionViewCell.cache.cachedResponse(for: URLRequest(url: url)),
                let image = UIImage(data: cachedResponse.data) {
                photoImageView.image = image
                return
            }
            //Otherwise we need to fetch data from the URL
            imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
                guard let strongSelf = self else { return }

                strongSelf.imageDataTask = nil

                guard let data = data, let image = UIImage(data: data), error == nil else { return }

                DispatchQueue.main.async {
                    UIView.transition(with: strongSelf.photoImageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                        strongSelf.photoImageView.image = image
                    }, completion: nil)
                }
            }

            imageDataTask?.resume()
        }

    }
