//
//  GenerateImageAssembler.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import UIKit

final class GenerateImageAssembler {
	func configurator(showPictureDelegate: IShowPictureDelegate) -> UIViewController {
		// Подключение сервисов.
		let assemblerURL = AssemblerURLService()

		// Подключение менеджеров.
		let networkManager = NetworkManager()
		let decodeJSONManager = DecodeJsonManager()
		let networkKingfisherManager = NetworkKingfisherManager()

		let networkImageService = GenerateImageNetworkService(
			assemblerURL: assemblerURL,
			networkManager: networkManager,
			decodeJSONManager: decodeJSONManager,
			networkKingfisherManager: networkKingfisherManager
		)

		// Подключение Worker, запросы к данным, декодирование.
		let worker = GenerateImageWorker(generateImageNetwork: networkImageService)
		// Подключение VIP цикла.
		let viewController = GenerateImageViewController()
		let presenter = GenerateImagePresenter(
			viewController: viewController,
			showPictureDelegate: showPictureDelegate
		)
		let iterator = GenerateImageIterator(
			worker: worker,
			presenter: presenter
		)

		viewController.iterator = iterator
		return viewController
	}
}
