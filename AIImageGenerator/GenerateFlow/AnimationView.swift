//
//  AnimationView.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 01.03.2024.
//

import UIKit
import SnapKit
import Lottie

// MARK: - Class Your class
final class AnimationView: UIView {

	// MARK: - Public properties

	// MARK: - Dependencies
	var delegate: IUpdateTimer?

	// MARK: - Private properties
	// Плашка с анимацией.
	private lazy var viewBackground = createView()
	private lazy var labelTimer = createUILabel()
	private lazy var imageLotte = createAnimationView()
	private let customTimer = TimerManager(delegate: nil)
	// private lazy var animationView = createAnimationView()

	// MARK: - Initializator
	convenience init() {
		self.init(frame: CGRect.zero)
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
	func startAnimation() {
		self.customTimer.startTimer()
		self.customTimer.delegate = self
		imageLotte.play()
	}

	func stopAnimation() {
		imageLotte.stop()
	}
}

// MARK: - Add UIView.
private extension AnimationView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			viewBackground,
			labelTimer,
			imageLotte
		]
		views.forEach(addSubview)
	}
}

// MARK: - UI configuration.
private extension AnimationView {
	/// Настройка UI элементов
	func setupConfiguration() {
		viewBackground.backgroundColor = UIColor.clear
		labelTimer.text = "Estimated time"
		labelTimer.layer.borderWidth = 1
	}
}

// MARK: - Add constraint.
private extension AnimationView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		viewBackground.snp.makeConstraints { background in
			background.top.bottom.equalToSuperview()
			background.left.right.equalToSuperview()
		}

		labelTimer.snp.makeConstraints { timer in
			timer.top.equalTo(viewBackground.snp.top)
			timer.left.equalTo(viewBackground.snp.left).inset(10)
			timer.right.equalTo(viewBackground.snp.right).inset(10)
			timer.height.equalTo(60)
		}

		imageLotte.snp.makeConstraints { lotte in
			lotte.top.equalTo(labelTimer.snp.bottom)
			lotte.left.equalTo(viewBackground.snp.left)
			lotte.right.equalTo(viewBackground.snp.right)
			lotte.bottom.equalTo(viewBackground.snp.bottom)
		}
	}
}

// MARK: - YourClass Layout.
extension AnimationView { }

// MARK: - YourClass Source and Delegate.
extension AnimationView { }

// MARK: - UI Fabric.
private extension AnimationView {
	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

	func createUILabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = UIColor.white
		label.font = FontsStyle.semiboldSF(26).font
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createAnimationView() -> LottieAnimationView {
		var animationView = LottieAnimationView()
		animationView = .init(name: "AnimationClock")
		animationView.frame = CGRect(
			x: viewBackground.center.x - ( viewBackground.bounds.width - 60) / 2,
			y: viewBackground.bounds.height,
			width: viewBackground.bounds.width - 60,
			height: viewBackground.bounds.width - 60
		)
		animationView.loopMode = .loop
		animationView.animationSpeed = 0.5
		return animationView
	}

	func createLotte() -> LottieAnimationView {
		var animationView = LottieAnimationView()
		animationView = .init(name: "AnimationClock")
		animationView.loopMode = .loop
		animationView.animationSpeed = 0.5
		return animationView
	}
}

// MARK: Add TimerManager.
extension AnimationView: IUpdateTimer {
	func updateLabel(returnTime: String) {
		labelTimer.text = "Estimated time \(returnTime)"
	}

	func stopTimer() {
		labelTimer.text = "We need a little bit more time..."
	}
}
