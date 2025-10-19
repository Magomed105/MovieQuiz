import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    
    @IBOutlet private var imageView: UIImageView!
    //@IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var indexLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
   // @IBOutlet private var questionTitleLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    
    private var resultPresenter: ResultPresenter!
    private var statisticService: StatisticServiceProtocol =  StatisticService()
    private let alertPresenter = AlertPresenter()
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswer = 0
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func show(quiz result: QuizResultViewModel) {
        let model = AlertModel(title: result.title , message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            
            questionFactory?.requestNextQuestion()
            
        }
        alertPresenter.show(in: self, model: model)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.gamesCount += 1
            statisticService.store(correct: correctAnswer, total: questionsAmount)
            
            let viewModel = resultPresenter.makeResultViewModel(correctAnswers: correctAnswer)
            imageView.layer.borderWidth = 0
            show(quiz: viewModel)
        } else {
            imageView.layer.borderWidth = 0
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect {
            correctAnswer += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor :
        UIColor.ypRed.cgColor
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else  {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 2
        imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = true
        
        questionFactory = QuestionFactory()
        questionFactory?.delegate = self
        
        resultPresenter = ResultPresenter(statisticService: statisticService, questionsAmount: questionsAmount)
        
        questionFactory?.requestNextQuestion()
    }
}




