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

final class ImageViewerItemViewController: UIViewController {
    let index: Int // Necessary to keep track of index in UIPageViewController
    private let item: ImageViewerItem
    private let delegate: ImageViewerItemViewControllerDelegate

    init?(coder: NSCoder, index: Int, item: ImageViewerItem, delegate: ImageViewerItemViewControllerDelegate) {
        self.index = index
        self.item = item
        self.delegate = delegate
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var scrollView: UIScrollView!

    private var imageView = UIImageView()
    private var imageViewLeadingConstraint: NSLayoutConstraint!
    private var imageViewTopConstraint: NSLayoutConstraint!

    @IBOutlet private var doubleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet private var swipeGestureRecognizer: UISwipeGestureRecognizer!
}

// MARK: - Lifecycle

extension ImageViewerItemViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)

        imageViewLeadingConstraint = NSLayoutConstraint(item: imageView,
                                                        attribute: .leading,
                                                        relatedBy: .equal,
                                                        toItem: scrollView,
                                                        attribute: .leading,
                                                        multiplier: 1,
                                                        constant: 0)

        imageViewTopConstraint = NSLayoutConstraint(item: imageView,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: scrollView,
                                                    attribute: .top,
                                                    multiplier: 1,
                                                    constant: 0)

        scrollView.addConstraints([imageViewLeadingConstraint, imageViewTopConstraint])

        navigationController?.hidesBarsOnTap = true
        navigationController?.barHideOnTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)

        activityIndicatorView.startAnimating()

        item.setImage(for: imageView) {
            self.activityIndicatorView.stopAnimating()

            self.delegate.imageViewerItemViewController(controller: self,
                                                        didSetImage: self.imageView.image)

            self.updateImageConstraints()
            self.updateZoomScale(animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateImageConstraints()
        updateZoomScale(animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateImageConstraints()
        updateZoomScale(animated: false)

        // Force refresh zoom
        let zoomScale = scrollView.zoomScale
        scrollView.zoomScale = scrollView.zoomScale + 0.1
        scrollView.zoomScale = zoomScale
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        updateZoomScale(animated: true)
    }
}

// MARK: - UIScrollViewDelegate

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
    private func updateZoomScale(animated: Bool) {
        guard let image = imageView.image else { return }

        let widthScale = view.bounds.width/image.size.width
        let heightScale = view.bounds.height/image.size.height
        let scale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = scale * 3
        scrollView.setZoomScale(scale, animated: animated)

        scrollView.contentInset = UIEdgeInsets(top: -scrollView.safeAreaInsets.top, left: -scrollView.safeAreaInsets.left, bottom: -scrollView.safeAreaInsets.bottom, right: -scrollView.safeAreaInsets.right)

        scrollView.isDirectionalLockEnabled = scrollView.zoomScale == scrollView.minimumZoomScale
    }

    private func updateImageConstraints() {
        let horizontalOffset = max(0, (view.bounds.width - imageView.frame.width)/2)
        imageViewLeadingConstraint.constant = horizontalOffset

        let verticalOffset = max(0, (view.bounds.height - imageView.frame.height)/2)
        imageViewTopConstraint.constant = verticalOffset

        view.layoutIfNeeded()
    }
}

// MARK: - Controls

extension ImageViewerItemViewController {
    @IBAction private func doubleTapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        let scale = scrollView.zoomScale > scrollView.minimumZoomScale ? scrollView.minimumZoomScale : scrollView.maximumZoomScale

        if scale != scrollView.zoomScale {
            let point = sender.location(in: imageView)

            let size = CGSize(width: view.bounds.width/scale, height: view.bounds.height/scale)
            let origin = CGPoint(x: point.x - size.width/2, y: point.y - size.height/2)

            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
    }

    @IBAction private func swipeGestureRecognizerAction(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true)
    }
}
