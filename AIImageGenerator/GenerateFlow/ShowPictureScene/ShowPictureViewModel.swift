//
//  ShowPictureViewModel.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import UIKit
import SnapKit
import EasyTipView
import AudioToolbox

protocol IShowPictureLogic: AnyObject {
	func renderImage(viewModel: SPViewModel)
	func showSaveImage()
}

final class ShowPictureViewController: UIViewController {

	// MARK: - Public properties

	// MARK: - Dependencies
	var iterator: IShowPictureIterator?

	// MARK: - Private properties
	// Создание UI элементов.
	private lazy var imageBackground = createImage()
	private lazy var imageLockScreen = createImage()
	private lazy var buttonBack = createButton(systemName: "chevron.left")
	private lazy var buttonShowScreen = createButton(systemName: "eye")
	private lazy var buttonSaveImage = createButton(systemName: "arrow.down")
	// Создание жеста.
	private var pinchGesture = UIPinchGestureRecognizer()
	private var identity = CGAffineTransform.identity
	/// Создание EasyTipView элемента.
	var preferences = EasyTipView.Preferences()
	private lazy var tipViewForButtonSave = EasyTipView(text: "Save in photo.", preferences: preferences)

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
		iterator?.fetch()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupLayout()
		navigationController?.setNavigationBarHidden(true, animated: false)
		let image = UIImage(named: "Images/IphoneLockScreen")
		imageLockScreen.image = image?.resized(to: self.view.frame.size)
	}
}

// MARK: - Add UIView.
private extension ShowPictureViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			imageBackground,
			buttonBack,
			buttonShowScreen,
			buttonSaveImage,
			imageLockScreen
		]
		views.forEach(view.addSubview)
	}
}

// MARK: - UI configuration.
private extension ShowPictureViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		// Прячем по умолчанию изображение заставки.
		imageLockScreen.isHidden = true
		// Кнопка сохранение.
		buttonSaveImage.addTarget(self, action: #selector(saveImageInLibrary), for: .touchUpInside)
		// Кнопка назад.
		buttonBack.addTarget(self, action: #selector(backToView), for: .touchUpInside)

		buttonShowScreen.addTarget(self, action: #selector(showLockScreen), for: .touchUpInside)

		// Добавляем метод для зуммирования.
		imageBackground.isUserInteractionEnabled = true
		pinchGesture.addTarget(self, action: #selector(zoomingImage))
		imageBackground.addGestureRecognizer(pinchGesture)
		// Настройки EasyTipView.
		configureTipView()
	}

	func configureTipView() {
		preferences.drawing.font = FontsStyle.semiboldSF(18).font
		preferences.drawing.foregroundColor = UIColor.white
		preferences.drawing.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		preferences.drawing.arrowHeight = 10
		preferences.drawing.arrowWidth = 15
		preferences.drawing.cornerRadius = 13
		preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
		EasyTipView.globalPreferences = preferences
		tipViewForButtonSave.translatesAutoresizingMaskIntoConstraints = false
	}
}

// MARK: - Add constraint.
private extension ShowPictureViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		imageBackground.snp.makeConstraints { image in
			image.centerX.equalToSuperview()
			image.center.equalToSuperview()
			image.top.bottom.equalToSuperview()
			image.left.right.equalToSuperview()
		}
		imageLockScreen.snp.makeConstraints { lockScreen in
			lockScreen.top.bottom.equalToSuperview()
			lockScreen.left.right.equalToSuperview()
		}

		buttonBack.snp.makeConstraints { back in
			back.top.equalToSuperview().inset(70)
			back.left.equalToSuperview().inset(20)
			back.width.height.equalTo(50)
		}
		buttonShowScreen.snp.makeConstraints { show in
			show.bottom.equalToSuperview().inset(100)
			show.left.equalToSuperview().inset(20)
			show.width.height.equalTo(50)
		}
		buttonSaveImage.snp.makeConstraints { save in
			save.bottom.equalToSuperview().inset(100)
			save.right.equalToSuperview().inset(20)
			save.width.height.equalTo(50)
		}
	}
}

// MARK: - UI Fabric.
private extension ShowPictureViewController {
	func createButton(systemName: String) -> UIButton {
		let button = UIButton()
		let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
		let image = UIImage(systemName: systemName, withConfiguration: configuration)
		button.setImage(image, for: .normal)
		button.backgroundColor = UIColor.black
		button.tintColor = UIColor.white
		button.layer.borderWidth = 3
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.cornerRadius = 25
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}

	func createImage() -> UIImageView {
		let image = UIImage()
		let imageView = UIImageView(image: image)
		imageView.tintColor = UIColor.gray
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}
}

// MARK: - UI Action.
extension ShowPictureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	// Метод зуммирования изображения.
	@objc private func zoomingImage(_ gesture: UIPinchGestureRecognizer) {
		switch gesture.state {
		case .began:
			identity = imageBackground.transform
		case .changed, .ended:
			imageBackground.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
		case .cancelled, .possible, .failed:
			break
		@unknown default:
			break
		}
		imageBackground.center = view.center
	}

	// Метод для сохранения изображения.
	@objc func saveImageInLibrary() {
		if let currentImage = imageBackground.image {
			buttonSaveImage.isEnabled = false
			AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
			iterator?.saveImage(image: currentImage)
		}
	}
	// Метод выхода из данного экрана.
	@objc func backToView() {
		iterator?.backToView()
	}
	// Метод отображения изображения заблокированного экрана.
	@objc func showLockScreen() {
		imageLockScreen.isHidden.toggle()
	}
}

// MARK: - Animation.
private extension ShowPictureViewController {
	func showTipView() {
		DispatchQueue.main.async {
			self.tipViewForButtonSave.show(forView: self.buttonSaveImage, withinSuperview: self.view)
			self.hideTipView()
		}
	}

	func hideTipView() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			self.tipViewForButtonSave.dismiss()
			self.buttonSaveImage.isEnabled = true
		}
	}
}

// MARK: - Render logic.
extension ShowPictureViewController: IShowPictureLogic {
	func renderImage(viewModel: SPViewModel) {
		self.imageBackground.image = UIImage(data: viewModel.imageData)
	}
	func showSaveImage() {
		showTipView()
	}
}
