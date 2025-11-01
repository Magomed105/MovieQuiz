import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var indexLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDependencies()
        configureUI()
        startInitialDataLoad()
    }
    
    private func configureDependencies() {
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    private func configureUI() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.backgroundColor = .clear
    }
    
    private func startInitialDataLoad() {
        showLoadingIndicator()
    }
    
    // MARK: - Private Methods
    func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.isHidden = false // говорим, что индикатор загрузки не скрыт
            self?.activityIndicator?.startAnimating() // включаем анимацию
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.isHidden = true
            self?.activityIndicator?.stopAnimating()
        }
    }
    
    func resetImageBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func updateButtonsState(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
        noButton.alpha = isEnabled ? 1 : 0.5
        yesButton.alpha = isEnabled ? 1 : 0.5
    }
    
    // Приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz step: QuizStepViewModel) {
        // Гарантированный сброс рамки перед новым вопросом
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        //Добавили анимацию для плавного появления изображения
        UIView.transition(with: imageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageView.image = step.image
            self.questionLabel.text = step.question
            self.indexLabel.text = step.questionNumber
        }
        )
    }
    // MARK: - Actions

    @IBAction func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
        updateButtonsState(isEnabled: false)
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
        updateButtonsState(isEnabled: false)
    }
}



