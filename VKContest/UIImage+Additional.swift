//
//  UIImage+Additional.swift
//  VKContest
//
//  Created by g.tokmakov on 11/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

extension UIImage {
    class func vkc_image(imageName: String, renderingMode: UIImage.RenderingMode) -> UIImage? {
        return UIImage(named: imageName)?.withRenderingMode(renderingMode)
    }
}
