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
		// Подключение менеджеры.
		let networkManager = NetworkManager()
		let decodeJSONManager = DecodeJsonManager()
		// Подключение конверторов.
		let converterDTO = ConvertGenerateImageDTO()
		// Подключение Worker, запросы к данным, декодирование.
		let worker = GenerateImageWorker(
			assemblerURL: assemblerURL,
			networkManager: networkManager,
			decodeJSONManager: decodeJSONManager
		)
		// Подключение VIP цикла.
		let viewController = GenerateImageViewController()
		let presenter = GenerateImagePresenter(
			viewController: viewController,
			showPictureDelegate: showPictureDelegate
		)
		let iterator = GenerateImageIterator(
			worker: worker,
			presenter: presenter,
			converterDTO: converterDTO
		)

		viewController.iterator = iterator
		return viewController
	}
}
