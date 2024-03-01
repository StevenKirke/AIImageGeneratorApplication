//
//  ShowPictureAssembler.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import UIKit

final class ShowPictureAssembler {

	// MARK: - Private properties

	// MARK: - Public methods
	/// Отображение второй сцены.
	/// - Parameters:
	///		- model: Тип ShowPictureModel.Request.Передаем URL изображения.
	func configurator(imageData: Data, backSceneDelegate: IBackShowPictureDelegate) -> UIViewController {
		// Подключение менеджеров.
		let savePhotoManager = SavePhotoManager()

		// Подключение VIP цикла.
		let viewController = ShowPictureViewController()
		let presenter = ShowPicturePresenter(viewController: viewController, backSceneHandler: backSceneDelegate)
		let iterator = ShowPictureIterator(
			presenter: presenter,
			savePhotoManager: savePhotoManager,
			model: imageData
		)

		viewController.iterator = iterator
		return viewController
	}
}
