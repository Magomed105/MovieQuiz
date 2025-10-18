//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Allianse on 18.10.2025.
//
import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get set  }
    var bestGame: GameResult { get set }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}


