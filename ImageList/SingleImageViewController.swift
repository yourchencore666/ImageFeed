//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 06.12.2022.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return} // загружено ли view
            imageView.image = image // попадаем сюда если был загружен SingleImageViewController
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
