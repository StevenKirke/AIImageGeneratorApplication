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
	func renderImage(viewControllerText: String)
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
	private var animationView: LottieAnimationView?

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

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupLayout()
		gradient.frame = view.bounds

		animationView = .init(name: "AnimationClock")
		animationView?.frame = CGRect(x: 30, y: 30, width: 200, height: 200)
		animationView?.loopMode = .loop
		animationView?.animationSpeed = 0.5
		view.addSubview(animationView!)
		animationView?.play()
	}

	// MARK: - Public methods
	func reloadData() { }
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
		viewBackground.backgroundColor = UIColor.green
		viewBackground.layer.insertSublayer(gradient, at: 0)

		buttonGetImage.addTarget(self, action: #selector(hendlerTextField), for: .touchUpInside)
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
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		let configuration = UIImage.SymbolConfiguration(textStyle: .title1)
		let image = UIImage(systemName: "arrow.up", withConfiguration: configuration)
		button.setImage(image, for: .normal)
		button.backgroundColor = UIColor(hex: "#370258")
		button.tintColor = UIColor.white
		button.layer.borderWidth = 3
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.cornerRadius = 15
		button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
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
	@objc func hendlerTextField() {
		// Скрываем клавиатуру.
		UIApplication.shared.endEditing()
		// Проверка текстового поля на пустоту и другие операции с ним.
		if let text = textField.text {
			getData(text: text)
			textField.text = ""
		}
	}
}
// MARK: - Iterator.
private extension GenerateImageViewController {
	// Запрос в Iterator.
	func getData(text: String) {
		let size = CGSize(width: view.frame.width, height: view.frame.height)
		let prompt = MainSearchViewModel.Response.ImageData(prompt: text, size: size)
		animationView?.stop()
		// iterator?.fetch(responsePrompt: .success(prompt))
	}
}

// MARK: - Render logic.
extension GenerateImageViewController: IGenerateImageLogic {
	func renderImage(viewControllerText: String) {
		print(viewControllerText)
	}
}
