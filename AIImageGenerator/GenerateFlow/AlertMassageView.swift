//
//  AlertMassageView.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 28.02.2024.
//

import UIKit
import SnapKit

// Обработчик кнопок для AlertMassageView.
protocol IAlertMassageViewDelegate: AnyObject {
	/// Метод для обработки нажатия положительного действия.
	func tapAgain()
	/// Метод для обработки нажатия отрицательного действия.
	func tapCancel()
}

// MARK: - Class Your class
final class AlertMassageView: UIView {

	// MARK: - Public properties
	var handlerTabButtons: IAlertMassageViewDelegate?
	// MARK: - Dependencies

	// MARK: - Private properties
	private lazy var backgroundView = createView()
	private lazy var labelTitle = createUILabel()
	private lazy var labelDescription = createUILabel()
	private lazy var buttonOK = createButton("Try again")
	private lazy var buttonCancel = createButton("Cancel")

	// MARK: - Initializator
	convenience init(handlerTabButtons: IAlertMassageViewDelegate?) {
		self.init(frame: CGRect.zero)
		self.handlerTabButtons = handlerTabButtons
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		addUIView()
		setupConfiguration()
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public methods
	func reloadData(massage: String) {
		labelDescription.text = massage
	}
}

// MARK: - Add UIView.
private extension AlertMassageView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			backgroundView,
			labelTitle,
			labelDescription,
			buttonOK,
			buttonCancel
		]
		views.forEach(addSubview)
	}
}

// MARK: - UI configuration.
private extension AlertMassageView {
	/// Настройка UI элементов
	func setupConfiguration() {
		backgroundView.backgroundColor = UIColor.white
		backgroundView.layer.cornerRadius = 20

		// Настройка label title.
		labelTitle.text = "oooops!"
		labelTitle.font = FontsStyle.semiboldSF(22).font

		// Настройка label описание ошибки.
		labelDescription.font = FontsStyle.semiboldSF(18).font
		labelDescription.numberOfLines = 0
		labelDescription.textAlignment = .left

		// Настройка кнопки снова.
		buttonOK.setTitleColor(.white, for: .normal)
		buttonOK.setTitleColor(.gray, for: .selected)
		buttonOK.backgroundColor = UIColor(hex: "#370258")
		buttonOK.addTarget(self, action: #selector(tapAgain), for: .touchUpInside)

		// Настройка кнопки отмены.
		buttonCancel.setTitleColor(.black, for: .normal)
		buttonCancel.setTitleColor(.gray, for: .selected)
		buttonCancel.backgroundColor = UIColor.white
		buttonCancel.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
	}
}

// MARK: - Add constraint.
private extension AlertMassageView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		backgroundView.snp.makeConstraints { background in
			background.top.bottom.equalToSuperview()
			background.left.right.equalToSuperview()
		}

		labelTitle.snp.makeConstraints { title in
			title.top.equalToSuperview().inset(10)
			title.left.equalTo(backgroundView.snp.left).inset(20)
			title.right.equalTo(backgroundView.snp.right).inset(20)
			title.height.equalTo(60)
		}

		labelDescription.snp.makeConstraints { description in
			description.top.equalTo(labelTitle.snp.bottom).inset(-10)
			description.left.equalTo(backgroundView.snp.left).inset(20)
			description.right.equalTo(backgroundView.snp.right).inset(20)
		}

		buttonOK.snp.makeConstraints { okay in
			okay.bottom.equalTo(buttonCancel.snp.top).inset(-20)
			okay.left.equalTo(backgroundView.snp.left).inset(20)
			okay.right.equalTo(backgroundView.snp.right).inset(20)
			okay.height.equalTo(46)
		}

		buttonCancel.snp.makeConstraints { cancel in
			cancel.bottom.equalTo(backgroundView.snp.bottom).inset(20)
			cancel.left.equalTo(backgroundView.snp.left).inset(20)
			cancel.right.equalTo(backgroundView.snp.right).inset(20)
			cancel.height.equalTo(46)
		}
	}
}

// MARK: - UI Fabric.
private extension AlertMassageView {
	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

	func createUILabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createButton(_ title: String) -> UIButton {
		let button = UIButton()
		button.setTitle(title, for: .normal)
		button.layer.cornerRadius = 10
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}
}

// MARK: - UI Action.
private extension AlertMassageView {
	@objc func tapAgain() {
		handlerTabButtons?.tapAgain()
	}

	@objc func tapCancel() {
		handlerTabButtons?.tapCancel()
	}
}

// MARK: - Render logic.
private extension AlertMassageView { }
