//
//  GenerateImagePresenter.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import Foundation

protocol IGenerateImagePresenter: AnyObject {
	func present(present: MSRequest)
}

final class GenerateImagePresenter {

	// MARK: - Dependencies
	private var showPictureDelegate: IShowPictureDelegate?

	// MARK: - Initializator
	init(
		viewController: IGenerateImageLogic?,
		showPictureDelegate: IShowPictureDelegate?
	) {
		self.viewController = viewController
		self.showPictureDelegate = showPictureDelegate
	}

	// MARK: - Lifecycle
	private weak var viewController: IGenerateImageLogic?
}

extension GenerateImagePresenter: IGenerateImagePresenter {
	func present(present: MSRequest) {
		switch present {
		case .success(let imageData):
			// Конвертируем модель для следующего VIP цикла.
			let modelResponse = ShowPictureModel.Response.ImageData(from: imageData)
			viewController?.handlerLogic()
			showPictureDelegate?.showImageScene(model: .success(modelResponse))
		case .failure(let error):
			print("Error \(error)")
			viewController?.handlerLogic()
		}
	}
}
