//
//  ViewController.swift
//  Demo
//
//  Created by Caio Mello on 17.09.20.
//

import UIKit
import ImageViewer

final class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let imageViewer = ImageViewer.instantiate(items: [ImageViewerItem(setImageBlock: { (imageView, completion) in
            imageView.image = #imageLiteral(resourceName: "Example")
            completion()
        })], index: 0)

        imageViewer.modalPresentationStyle = .fullScreen

        present(imageViewer, animated: true)
    }
}
