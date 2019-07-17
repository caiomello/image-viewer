//
//  ImageViewerPageViewController.swift
//  ImageViewer
//
//  Created by Caio Mello on May 30, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import UIKit

final class ImageViewerPageViewController: UIPageViewController {
    private let imageViewerDataSource: ImageViewerDataSource
    private var index: Int

    init?(coder: NSCoder, dataSource: ImageViewerDataSource, index: Int) {
        self.imageViewerDataSource = dataSource
        self.index = index
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

	@IBOutlet private var shareBarButton: UIBarButtonItem!

	private var currentViewController: ImageViewerItemViewController?
    private var currentImage: UIImage?
}

// MARK: - Lifecycle

extension ImageViewerPageViewController {
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource = self
		delegate = self
		
		setViewControllers([imageViewerItemViewController(withIndex: index)], direction: .forward, animated: false, completion: nil)
		currentViewController = viewControllers?.first as? ImageViewerItemViewController
	}
}

// MARK: - UIPageViewControllerDataSource

extension ImageViewerPageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if index > 0 {
            return imageViewerItemViewController(withIndex: index - 1)
        }

		return nil
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if index < (imageViewerDataSource.numberOfItems() - 1) {
            return imageViewerItemViewController(withIndex: index + 1)
        }

        return nil
	}
}

// MARK: - UIPageViewControllerDelegate

extension ImageViewerPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let itemViewController = viewControllers?.first as? ImageViewerItemViewController {
            currentViewController = itemViewController
            shareBarButton.isEnabled = currentImage != nil
        }
    }
}

// MARK: - Helpers

extension ImageViewerPageViewController {
	private func imageViewerItemViewController(withIndex index: Int) -> ImageViewerItemViewController {
        let storyboard = UIStoryboard(name: "\(ImageViewerItemViewController.self)", bundle: Bundle(for: ImageViewer.self))

        let itemViewController = storyboard.instantiateInitialViewController { coder -> ImageViewerItemViewController? in
            ImageViewerItemViewController(coder: coder, item: self.imageViewerDataSource.itemAtIndex(index), delegate: self)
        }

        return itemViewController!
	}
}

// MARK: - ImageViewerItemViewController

extension ImageViewerPageViewController: ImageViewerItemViewControllerDelegate {
	func imageViewerItemViewController(controller: ImageViewerItemViewController, didSetImage image: UIImage?) {
        currentImage = image
		shareBarButton.isEnabled = image != nil
	}
}

// MARK: - Controls

extension ImageViewerPageViewController {
	@IBAction private func shareBarButtonAction(_ sender: UIBarButtonItem) {
		if let image = currentImage {
			let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
			activityViewController.popoverPresentationController?.barButtonItem = sender
			present(activityViewController, animated: true, completion: nil)
		}
	}
	
	@IBAction private func doneBarButtonAction(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
}
