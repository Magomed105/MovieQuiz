//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Allianse on 16.10.2025.
//

import Foundation
struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
