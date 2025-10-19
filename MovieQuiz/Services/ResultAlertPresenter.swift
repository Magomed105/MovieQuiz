import Foundation

final class ResultPresenter {
    private let statisticService: StatisticServiceProtocol
    private let questionsAmount: Int

    init(statisticService: StatisticServiceProtocol, questionsAmount: Int) {
        self.statisticService = statisticService
        self.questionsAmount = questionsAmount
    }

    func makeResultViewModel(correctAnswers: Int) -> QuizResultViewModel {
        let text: String
        if correctAnswers == questionsAmount {
            text = "Поздравляем, вы ответили на все \(questionsAmount) вопросов!"
        } else {
            text = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        }

        let playedTimes = "\nКоличество сыгранных квизов: \(statisticService.gamesCount)"
        let record = "\nВаш рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(statisticService.bestGame.date.dateTimeString))"
        let accuracy = "\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"

        return QuizResultViewModel(
            title: "Этот раунд окончен!",
            text: text + playedTimes + record + accuracy,
            buttonText: "Сыграть еще раз"
        )
    }
}

