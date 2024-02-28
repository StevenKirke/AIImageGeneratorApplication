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
	func configurator(model: SPResponse, backSceneDelegate: IBackShowPictureDelegate) -> UIViewController {
		// Подключение менеджеров.
		let savePhotoManager = SavePhotoManager(handlerSaveImage: self)

		// Подключение VIP цикла.
		let viewController = ShowPictureViewController()
		let presenter = ShowPicturePresenter(viewController: viewController, backSceneHandler: backSceneDelegate)
		let iterator = ShowPictureIterator(
			presenter: presenter,
			savePhotoManager: savePhotoManager,
			model: model
		)

		viewController.iterator = iterator
		return viewController
	}
}

extension ShowPictureAssembler: IReturnResultSavePhotoDelegate {
	func returnResultSaveImage(result: Result<Bool, Error>) {
		print("result \(result)")
	}
}
