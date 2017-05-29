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

public class ImageViewer: UIPageViewController {
	@IBOutlet fileprivate var shareBarButton: UIBarButtonItem!
	
	var imageDataSource: ImageViewerDataSource!
	var initialIndex = 0
	
	fileprivate var currentViewController: ImageViewerItemViewController?
}

// MARK: - View

extension ImageViewer {
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource = self
		delegate = self
		
		setViewControllers([imageViewerItemViewController(withIndex: initialIndex)], direction: .forward, animated: false, completion: nil)
	}
}

// MARK: - PageViewController

extension ImageViewer: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if let itemViewController = viewController as? ImageViewerItemViewController {
			if itemViewController.index > 0 {
				return imageViewerItemViewController(withIndex: itemViewController.index - 1)
			}
		}
		
		return nil
	}
	
	public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if let itemViewController = viewController as? ImageViewerItemViewController {
			if itemViewController.index < (imageDataSource.numberOfItems(self) - 1) {
				return imageViewerItemViewController(withIndex: itemViewController.index + 1)
			}
		}
		
		return nil
	}
	
	public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if completed, let itemViewController = viewControllers?.first as? ImageViewerItemViewController {
			currentViewController = itemViewController
			shareBarButton.isEnabled = itemViewController.imageView.image != nil
		}
	}
}

// MARK: - ImageViewerItemViewController

extension ImageViewer: ImageViewerItemViewControllerDelegate {
	func imageViewerItemViewController(controller: ImageViewerItemViewController, didSetImage image: UIImage?) {
		shareBarButton.isEnabled = image != nil
	}
}

// MARK: - Helpers

extension ImageViewer {
	fileprivate func imageViewerItemViewController(withIndex index: Int) -> ImageViewerItemViewController {
		let itemViewController = storyboard?.instantiateViewController(withIdentifier: "ImageViewerItem") as! ImageViewerItemViewController
		itemViewController.item = imageDataSource.imageViewer(self, itemAtIndex: index)
		itemViewController.index = index
		itemViewController.delegate = self
		return itemViewController
	}
}

// MARK: - Actions

extension ImageViewer {
	@IBAction fileprivate func shareBarButtonAction(_ sender: UIBarButtonItem) {
		if let image = currentViewController?.imageView.image {
			let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
			activityViewController.popoverPresentationController?.barButtonItem = sender
			present(activityViewController, animated: true, completion: nil)
		}
	}
	
	@IBAction fileprivate func doneBarButtonAction(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
}
