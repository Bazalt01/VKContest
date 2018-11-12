//
//  ImageService.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

enum ImageTypes {
    case user
    case group
    case news
}

class ImageService {
    private var queue: OperationQueue
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        self.queue = OperationQueue()
        self.queue.maxConcurrentOperationCount = 1
        self.queue.name = "database.service.queue"
    }
    
    // MARK: - Public
    
    func findAvatarOrLoadIfNeed(url: String, size: CGSize, completion:@escaping (_ image: UIImage?) -> ()) -> Int {
        return findImageOrLoadIfNeed(url: url, size: size) { [unowned self] image in
            guard let image = image else {
                completion(nil)
                return
            }
            completion(self.roundedImage(image: image, size: size))
        }
    }
    func findImageOrLoadIfNeed(url: String, size: CGSize, completion:@escaping (_ image: UIImage?) -> ()) -> Int {
        return networkService.downloadFile(urlString: url, success: { [unowned self] data in
            guard var image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            image = self.scaledImage(image: image, size: size)
            DispatchQueue.main.async {
                completion(image)
            }
        }) { error in
        }
    }
    
    func cancelLoadImage(processID: Int) {
        networkService.cancel(taskID: processID)
    }
    
    func roundedImage(image: UIImage, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return image }
        
        let radius = size.width/2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        context.beginPath()
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        context.closePath()
        if context.isPathEmpty == false {
            context.clip()
        }
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage ?? image
    }
    
    func scaledImage(image: UIImage, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return image }
        
        let scaleX = rect.width / image.size.width
        let scaleY = rect.height / image.size.height
        
        context.scaleBy(x: scaleX, y: scaleY)
        if context.isPathEmpty == false {
            context.clip()
        }
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage ?? image
    }
}


