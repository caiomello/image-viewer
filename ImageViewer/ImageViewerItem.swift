//
//  ImageViewerItem.swift
//  ImageViewer
//
//  Created by Caio Mello on May 27, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import UIKit

public struct ImageViewerItem {
    private let downloadBlock: ((_ completion: @escaping (UIImage?) -> Void) -> Void)?

    public init(downloadBlock: @escaping (_ completion: @escaping (UIImage?) -> Void) -> Void) {
        self.downloadBlock = downloadBlock
    }

    func downloadImage(_ completion: @escaping (UIImage?) -> Void) {
        downloadBlock?(completion)
    }
}
