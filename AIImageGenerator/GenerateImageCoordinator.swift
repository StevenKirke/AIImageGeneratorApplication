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

final class GenerateImageCoordinator: ICoordinator {

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
		// let URL = URL(string: "fsdfsd")!
		// showImageScene(model: SPResponse.success(.init(url: URL)))
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
		let showPictureVC = assembler.configurator(model: model)
		navigateController.pushViewController(showPictureVC, animated: true)
	}
}

private extension GenerateImageCoordinator {
	func handlerResult() {
		finish()
	}
}
