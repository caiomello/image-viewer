//
//  ImageViewerItemViewController.swift
//  ImageViewer
//
//  Created by Caio Mello on May 29, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import UIKit

protocol ImageViewerItemViewControllerDelegate {
	func imageViewerItemViewController(controller: ImageViewerItemViewController, didSetImage image: UIImage?)
}

class ImageViewerItemViewController: UIViewController {
	@IBOutlet fileprivate var activityIndicatorView: UIActivityIndicatorView!
	@IBOutlet fileprivate var scrollView: UIScrollView!
	@IBOutlet var imageView: UIImageView!
	
	@IBOutlet fileprivate var imageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet fileprivate var imageViewTopConstraint: NSLayoutConstraint!
	
	@IBOutlet fileprivate var tapGestureRecognizer: UITapGestureRecognizer!
	@IBOutlet fileprivate var doubleTapGestureRecognizer: UITapGestureRecognizer!
	
	var item: ImageViewerItem!
	var index = 0
	var delegate: ImageViewerItemViewControllerDelegate!
}

// MARK: - View

extension ImageViewerItemViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
		
		if let image = item.image {
			imageView.image = image
			delegate.imageViewerItemViewController(controller: self, didSetImage: image)
			
			updateImageConstraints()
			updateZoomScale()
			
		} else {
			activityIndicatorView.startAnimating()
			
			item.downloadImage({ (image) in
				self.activityIndicatorView.stopAnimating()
				
				self.imageView.image = image
				self.delegate.imageViewerItemViewController(controller: self, didSetImage: image)
				
				self.updateImageConstraints()
				self.updateZoomScale()
			})
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateImageConstraints()
		updateZoomScale()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		updateImageConstraints()
		updateZoomScale()
		
		// Force refresh zoom
		let zoomScale = scrollView.zoomScale
		scrollView.zoomScale = scrollView.zoomScale + 0.1
		scrollView.zoomScale = zoomScale
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
	}
}

// MARK: - ScrollView

extension ImageViewerItemViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		updateImageConstraints()
	}
}

// MARK: - Helpers

extension ImageViewerItemViewController {
	fileprivate func updateZoomScale() {
		guard let image = imageView.image else { return }
		
		let widthScale = view.bounds.width/image.size.width
		let heightScale = view.bounds.height/image.size.height
		let scale = min(widthScale, heightScale)
		
		scrollView.minimumZoomScale = scale
		scrollView.zoomScale = scale
	}
	
	fileprivate func updateImageConstraints() {
		let verticalOffset = max(0, (view.bounds.height - imageView.frame.height)/2)
		imageViewTopConstraint.constant = verticalOffset - scrollView.adjustedContentInset.top
		
		let horizontalOffset = max(0, (view.bounds.width - imageView.frame.width)/2)
		imageViewLeadingConstraint.constant = horizontalOffset
		
		view.layoutIfNeeded()
	}
}

// MARK: - Actions

extension ImageViewerItemViewController {
	@IBAction fileprivate func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction fileprivate func doubleTapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
//		if scrollView.zoomScale > scrollView.minimumZoomScale {
//			scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
//		} else {
			let scale = scrollView.zoomScale < 1 ? 1 : scrollView.minimumZoomScale
			
			if scale != scrollView.zoomScale {
				let point = sender.location(in: imageView)
				
				let size = CGSize(width: view.bounds.width/scale, height: view.bounds.height/scale)
				let origin = CGPoint(x: point.x - size.width/2, y: point.y - size.height/2)
				
				scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
			}
//		}
	}
}
