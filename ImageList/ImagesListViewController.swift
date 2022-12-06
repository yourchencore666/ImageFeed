//
//  ViewController.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 21.11.2022.
//

import UIKit

class ImagesListViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private var photosName = [String]()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        photosName = Array(0..<20).map{ "\($0)" }
    }
    
    // MARK: - Private Methods
    
    // MARK: - IBActions

}

    // MARK: - Table View Data Source

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "like_button_active") : UIImage(named: "like_button_no_active")
        
        cell.likeButton.setImage(likeImage, for: .normal)
        
    }
}
