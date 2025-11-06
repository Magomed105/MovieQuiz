import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didStartLoadingData()
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
