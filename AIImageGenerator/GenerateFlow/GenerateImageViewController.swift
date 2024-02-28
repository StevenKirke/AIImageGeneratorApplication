//
//  GenerateImageViewController.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import UIKit
import SnapKit
import Lottie

protocol IGenerateImageLogic: AnyObject {
	func handlerLogic()
}

final class GenerateImageViewController: UIViewController {

	// MARK: - Public properties

	// MARK: - Dependencies
	var iterator: IGenerateImageIterator?

	// MARK: - Private properties
	private lazy var viewBackground = createView()
	private lazy var gradient = createGradient()
	private lazy var textField = createTextField()
	private lazy var buttonGetImage = createButton()
	private lazy var animationView = createAnimationView()

	// MARK: - Initializator
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - Public methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConfiguration()
		addUIView()
		observeKeyboard()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		navigationController?.setNavigationBarHidden(true, animated: false)
		setupLayout()
		// Определяем размеры gradient для заднего фона.
		gradient.frame = view.bounds
	}
}

// MARK: - NotificationCenter
private extension GenerateImageViewController {
	func observeKeyboard() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
}

// MARK: - Add UIView.
private extension GenerateImageViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			viewBackground,
			textField,
			buttonGetImage
		]
		views.forEach(view.addSubview)
	}
}

// MARK: - UI configuration.
private extension GenerateImageViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		// Настройка бекграунда.
		viewBackground.backgroundColor = UIColor.green
		viewBackground.layer.insertSublayer(gradient, at: 0)

		textField.backgroundColor = UIColor.black
		// Определяем Z позицию для элементов, что бы спрятать блок анимации за textField.
		textField.layer.zPosition = viewBackground.layer.zPosition + 1
		buttonGetImage.layer.zPosition = textField.layer.zPosition + 1

		buttonGetImage.addTarget(self, action: #selector(handlerTextField), for: .touchUpInside)
	}
}

// MARK: - Add constraint.
private extension GenerateImageViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		viewBackground.snp.makeConstraints { background in
			background.top.bottom.equalToSuperview()
			background.left.right.equalToSuperview()
		}
		textField.snp.makeConstraints { textFL in
			textFL.bottom.equalToSuperview().inset(20)
			textFL.left.right.equalToSuperview().inset(15)
			textFL.height.equalTo(50)
		}
		buttonGetImage.snp.makeConstraints { button in
			button.centerY.equalTo(textField)
			button.right.equalTo(textField.snp.right).inset(10)
			button.width.height.equalTo(36)
		}
	}
}

// MARK: - UI Fabric.
private extension GenerateImageViewController {
	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

	func createButton() -> UIButton {
		let button = UIButton()
		let configuration = UIImage.SymbolConfiguration(textStyle: .title3)
		let image = UIImage(systemName: "arrow.up", withConfiguration: configuration)
		button.setImage(image, for: .normal)
		button.backgroundColor = UIColor(hex: "#370258")
		button.tintColor = UIColor.white
		button.layer.borderWidth = 3
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.cornerRadius = 18
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}

	func createAnimationView() -> LottieAnimationView {
		var animationView = LottieAnimationView()
		animationView = .init(name: "AnimationClock")
		animationView.frame = CGRect(
			x: view.center.x - (view.bounds.width - 60) / 2,
			y: view.bounds.height,
			width: view.bounds.width - 60,
			height: view.bounds.width - 60
		)
		animationView.loopMode = .loop
		animationView.animationSpeed = 0.5
		return animationView
	}

	func createGradient() -> CAGradientLayer {
		let gradient = CAGradientLayer()
		let colours = [
			UIColor(hex: "#370258").cgColor,
			UIColor(hex: "#000000").cgColor
		]
		gradient.colors = colours
		return gradient
	}

	func createTextField() -> UITextField {
		let textField = UITextField()
		textField.backgroundColor = UIColor.clear
		textField.textColor = UIColor.white
		textField.tintColor = UIColor.white
		textField.layer.borderColor = UIColor.white.cgColor
		textField.layer.borderWidth = 3
		textField.layer.cornerRadius = 12
		textField.setLeftPadding(20)
		textField.font = FontsStyle.semiboldSF(18).font
		textField.rightViewMode = .always
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}
}

// MARK: - UI Action.
private extension GenerateImageViewController {
	/// Поднимаем UITextField на высоту клавиатуры.
	@objc func keyboardShow(_ sender: NSNotification) {
		let keyboard = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
		guard let keyboardFrame = keyboard as? NSValue else { return }
		let keyboardRectangle = keyboardFrame.cgRectValue
		let keyboardHeight = keyboardRectangle.height
		self.view.frame.origin.y = -keyboardHeight
	}

	/// Опускаем UITextField.
	@objc func keyboardHide(sender: NSNotification) {
		self.view.frame.origin.y = .zero
	}

	/// Обрабатываем UITextField.
	@objc func handlerTextField() {
		// Скрываем клавиатуру.
		UIApplication.shared.endEditing()
		// Проверка текстового поля на пустоту и другие операции с ним.
		guard let text = textField.text else { return }
		if !text.isEmpty {
			showAnimationView()
			// Запрос на генерацию картинки.
			getData(text: text)
			// Блокируем кнопку запроса.
			buttonGetImage.isEnabled = false
		}
	}
}
// MARK: - Animation.
private extension GenerateImageViewController {
	// Запускаем и показываем animationView.
	func showAnimationView() {
		view.addSubview(animationView)
		 startAnimation()
		animationView.play()
	}
	// Отключаем анимацию и прячем animationView.
	func hideAnimationView() {
		stopAnimation()
		animationView.stop()
		view.willRemoveSubview(animationView)
	}

	func startAnimation() {
		let viewFrame = self.view.frame
		let centerX = self.view.bounds.midX - (self.view.bounds.width) / 2
		let centerY = self.view.bounds.midY + (self.animationView.frame.height)
		UIView.animate(
			withDuration: 1,
			delay: 0,
			options: [.curveEaseOut],
			animations: {
				self.animationView.transform = CGAffineTransform(translationX: centerX, y: -centerY)
			})
	}

	func stopAnimation() {
		let centerX = view.center.x - (view.bounds.width - 60) / 2
		let centerY = view.bounds.height
		UIView.animate(
			withDuration: 1,
			delay: 0,
			options: [.curveEaseOut],
			animations: {
				self.animationView.transform = CGAffineTransform(translationX: centerX, y: centerY)
			})
	}
}
// MARK: - Iterator.
private extension GenerateImageViewController {
	/// Методы для работы с Iterator.
	func getData(text: String) {
		let size = CGSize(width: view.frame.width, height: view.frame.height)
		let prompt = MainSearchViewModel.Response.ImageData(prompt: text, size: size)
		/// Запрос в Iterator.
		iterator?.fetch(responsePrompt: .success(prompt))
	}
}

// MARK: - Render logic.
extension GenerateImageViewController: IGenerateImageLogic {
	func handlerLogic() {
		// Очищаем поле ввода.
		textField.text = ""
		// Разблокируем кнопку запроса.
		buttonGetImage.isEnabled = true
		// Прячем анимацию загрузки.
		hideAnimationView()
	}
}
