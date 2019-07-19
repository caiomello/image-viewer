//
//  ImageViewerItem.swift
//  ImageViewer
//
//  Created by Caio Mello on May 27, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import UIKit

public struct ImageViewerItem {
    private let setImageBlock: (_ imageView: UIImageView, _ completion: @escaping () -> Void) -> Void

    public init(setImageBlock: @escaping (_ imageView: UIImageView, _ completion: @escaping () -> Void) -> Void) {
        self.setImageBlock = setImageBlock
    }

    func setImage(for imageView: UIImageView, completion: @escaping () -> Void) {
        setImageBlock(imageView, completion)
    }
}
