//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 22.11.2022.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
}
