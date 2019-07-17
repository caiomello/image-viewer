//
//  ImageViewer.swift
//  ImageViewer
//
//  Created by Caio Mello on May 27, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import UIKit

public protocol ImageViewerDataSource {
	func numberOfItems() -> Int
	func itemAtIndex(_ index: Int) -> ImageViewerItem
}

public class ImageViewer: UIViewController {
	public class func instantiate(dataSource: ImageViewerDataSource, index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "\(ImageViewerPageViewController.self)", bundle: Bundle(for: ImageViewer.self))

        let pageViewController = storyboard.instantiateInitialViewController { coder -> ImageViewerPageViewController? in
            ImageViewerPageViewController(coder: coder, dataSource: dataSource, index: index)
        }

        let navigationController = UINavigationController(rootViewController: pageViewController!)
        navigationController.navigationBar.barStyle = .black

        return navigationController
	}
}
