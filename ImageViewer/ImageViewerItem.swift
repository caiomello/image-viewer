//
//  ImageViewerItem.swift
//  ImageViewer
//
//  Created by Caio Mello on May 27, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import UIKit

public struct ImageViewerItem {
	let image: UIImage?
	let downloadBlock: ((_ completion: @escaping (UIImage?) -> Void) -> Void)?
	
	func downloadImage(_ completion: @escaping (UIImage?) -> Void) {
		downloadBlock?(completion)
	}
	
	public init(image: UIImage) {
		self.image = image
		self.downloadBlock = nil
	}
	
	public init(downloadBlock: @escaping (_ completion: @escaping (UIImage?) -> Void) -> Void) {
		self.image = nil
		self.downloadBlock = downloadBlock
	}
}
