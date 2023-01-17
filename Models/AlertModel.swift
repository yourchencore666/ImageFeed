//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Юрченко Артем on 17.01.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}
