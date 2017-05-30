//
//  ImageViewer.swift
//  ImageViewer
//
//  Created by Caio Mello on May 27, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import UIKit

public protocol ImageViewerDataSource {
	func numberOfItems(_ imageViewer: ImageViewer) -> Int
	func imageViewer(_ imageViewer: ImageViewer, itemAtIndex index: Int) -> ImageViewerItem
}

public class ImageViewer: UINavigationController {
	public var imageDataSource: ImageViewerDataSource!
	public var initialIndex = 0
	
	public class func imageViewer(withDataSource dataSource: ImageViewerDataSource, initialIndex: Int) -> ImageViewer {
		let storyboard = UIStoryboard(name: "ImageViewer", bundle: Bundle(for: ImageViewer.self))
		let imageViewer = storyboard.instantiateInitialViewController() as! ImageViewer
		let pageViewController = imageViewer.topViewController as! ImageViewerPageViewController
		pageViewController.imageViewer = imageViewer
		pageViewController.imageDataSource = dataSource
		pageViewController.initialIndex = initialIndex
		return imageViewer
		
	}
}

// MARK: - View

extension ImageViewer {
	override public func viewDidLoad() {
		super.viewDidLoad()
	}
}
