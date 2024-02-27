//
//  ShowPictureAssembler.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import UIKit

final class ShowPictureAssembler {
	/// Отображение второй сцены.
	/// - Parameters:
	///		- model: Тип ShowPictureModel.Request.Передаем URL изображения.
	func configurator(model: SPResponse) -> UIViewController {
		print("1 model \(model)")
		// Подключение VIP цикла.
		let viewController = ShowPictureViewController()
		let presenter = ShowPicturePresenter(viewController: viewController)
		let iterator = ShowPictureIterator(presenter: presenter, model: model)

		viewController.iterator = iterator
		return viewController
	}
}
