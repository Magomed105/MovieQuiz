import UIKit

protocol AlertPresenterProtocol {
    var viewController: UIViewController? { get set }
    func showResults(quiz model: AlertModel)
}
