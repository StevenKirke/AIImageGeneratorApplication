//
//  GenerateImageCoordinator.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import UIKit

protocol IShowPictureDelegate: AnyObject {
	/// Отображение второй сцены.
	/// - Parameters:
	///		- model: Тип ShowPictureModel.Request.Передаем URL изображения.
	func showImageScene(model: SPResponse)
}

protocol IBackShowPictureDelegate: AnyObject {
	/// Выход из текущей сцены.
	func backToScene()
}

final class GenerateImageCoordinator: NSObject, ICoordinator {

	// MARK: - Public properties
	var childCoordinators: [ICoordinator] = []

	// MARK: - Dependencies
	var navigateController: UINavigationController

	// MARK: - Private properties

	// MARK: - Initializator
	internal init(navigateController: UINavigationController) {
		self.navigateController = navigateController
	}

	// MARK: - Public methods
	func start() {
		showMainGenerateImageScene()
		// showFakeImageScene()
	}

	/// Отображение главной сцены текущего потока.
	func showMainGenerateImageScene() {
		let assembler = GenerateImageAssembler()
		let generateImageVC = assembler.configurator(showPictureDelegate: self)
		navigateController.pushViewController(generateImageVC, animated: true)
	}
}

extension GenerateImageCoordinator: IShowPictureDelegate {
	func showImageScene(model: SPResponse) {
		let assembler = ShowPictureAssembler()
		let showPictureVC = assembler.configurator(model: model, backSceneDelegate: self)
		showPictureVC.modalPresentationStyle = .fullScreen
		navigateController.present(showPictureVC, animated: true)
	}

	// Отображение изображения для тестирования текущей сцены.
	func showFakeImageScene() {
		let assembler = ShowPictureAssembler()
		let image = UIImage(named: "Images/itching")
		if let imageData = image?.pngData() {
			let model = ShowPictureModel.Response.success(ShowPictureModel.Response.ImageData(data: imageData))
			let showPictureVC = assembler.configurator(model: model, backSceneDelegate: self)
			showPictureVC.modalPresentationStyle = .fullScreen
			navigateController.present(showPictureVC, animated: true)
		}
	}
}

extension GenerateImageCoordinator: IBackShowPictureDelegate {
	func backToScene() {
		navigateController.dismiss(animated: true)
	}
}

private extension GenerateImageCoordinator {
	func handlerResult() {
		finish()
	}
}
