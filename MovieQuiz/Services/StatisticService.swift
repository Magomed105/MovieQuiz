import Foundation
class StatisticService {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case gamesCount
        case totalCorrectAnswers
        case totalQuestionsAsked
        case bestGame
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
}
extension StatisticService: StatisticServiceProtocol {
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        } set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    var totalAccuracy: Double {
        guard  totalQuestionsAsked > 0 else { return 0 }
        return Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100
    }
    
    var gamesCount: Int {
        get {
            let gamesCount = storage.integer(forKey: Keys.gamesCount.rawValue)
            return gamesCount
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        totalQuestionsAsked += amount
        totalCorrectAnswers += count
        
        let newGame = GameResult(correct: count, total: amount, date: Date())
        if newGame.isBetter(bestGame)  {
            bestGame = newGame
        }
    }
}


