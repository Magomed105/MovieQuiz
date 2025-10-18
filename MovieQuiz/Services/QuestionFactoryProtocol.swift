//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Allianse on 12.10.2025.
//
import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}
