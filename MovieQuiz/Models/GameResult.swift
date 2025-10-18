//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Allianse on 18.10.2025.
//
import Foundation
struct GameResult {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetter(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}

