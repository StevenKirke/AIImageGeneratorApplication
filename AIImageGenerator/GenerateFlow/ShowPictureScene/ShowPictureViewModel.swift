//
//  ShowPictureViewModel.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import UIKit
import SnapKit
import Kingfisher

protocol IShowPictureLogic: AnyObject {
	func renderImage(viewModel: SPViewModel.ImageURL)
}

final class ShowPictureViewController: UIViewController {

	// MARK: - Public properties

	// MARK: - Dependencies
	var iterator: IShowPictureIterator?

	// MARK: - Private properties
	private lazy var imageBackground = createImage()
	private lazy var buttonBack = createButton(systemName: "chevron.left")
	private lazy var buttonShowScreen = createButton(systemName: "eye")
	private lazy var buttonSaveImage = createButton(systemName: "arrow.down")

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
	}

	// MARK: - Public methods
	func reloadData() { }
}

// MARK: - Add UIView.
private extension ShowPictureViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			imageBackground,
			buttonBack,
			buttonShowScreen,
			buttonSaveImage
		]
		views.forEach(view.addSubview)
	}
}

// MARK: - UI configuration.
private extension ShowPictureViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		imageBackground.image = UIImage(named: "@image.png")

		buttonSaveImage.addTarget(self, action: #selector(saveImageInLibrary), for: .touchUpInside)
	}
}

// MARK: - Add constraint.
private extension ShowPictureViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		imageBackground.snp.makeConstraints { image in
			image.top.bottom.equalToSuperview()
			image.left.right.equalToSuperview()
		}
		buttonBack.snp.makeConstraints { back in
			back.top.equalToSuperview().inset(70)
			back.left.equalToSuperview().inset(20)
			back.width.height.equalTo(50)
		}
		buttonShowScreen.snp.makeConstraints { show in
			show.bottom.equalToSuperview().inset(50)
			show.left.equalToSuperview().inset(20)
			show.width.height.equalTo(50)
		}
		buttonSaveImage.snp.makeConstraints { save in
			save.bottom.equalToSuperview().inset(50)
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
		let image = UIImage(named: "Images/itching")
		let imageView = UIImageView(image: image)
		imageView.tintColor = UIColor.gray
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}
}

// MARK: - UI Action.
private extension ShowPictureViewController {
	@objc func saveImageInLibrary() {
		save()
	}
}
#warning("TODO: Закинуть итератор!")
extension ShowPictureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	func save() {
			guard let currentImage = imageBackground.image else { return }
			UIImageWriteToSavedPhotosAlbum(
				currentImage,
				self,
				#selector(image(_:didFinishSavingWithError:contextInfo:)),
				nil
			)
//			var imagePicker = UIImagePickerController()
//			imagePicker.delegate = self
//			imagePicker.sourceType = .photoLibrary
//			present(imagePicker, animated: true)
	}
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			print(error.localizedDescription)
		} else {
			print("Success")
		}
	}
}

// MARK: - Render logic.
extension ShowPictureViewController: IShowPictureLogic {
	func renderImage(viewModel: SPViewModel.ImageURL) {
		self.fetchImage(url: viewModel.url)
	}
}

private extension ShowPictureViewController {
	func fetchImage(url: URL) {
		KingfisherManager.shared.retrieveImage(with: url) { result in
			switch result {
			case .success(let image):
				let currentImage = try? result.get().image
				self.imageBackground.image = currentImage
			case .failure(let error):
				print("Error ShowPictureViewController \(error)")
			}
		}
	}
}
