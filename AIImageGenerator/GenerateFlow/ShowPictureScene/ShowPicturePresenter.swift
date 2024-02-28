//
//  ShowPicturePresenter.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import Foundation

protocol IShowPicturePresenter: AnyObject {
	func present(present: SPRequest)
	/// Назад на предыдущее View.
	func backToView()
}

final class ShowPicturePresenter {

	// MARK: - Private properties
	var backSceneHandler: IBackShowPictureDelegate?

	// MARK: - Initializator
	init(
		viewController: IShowPictureLogic?,
		backSceneHandler: IBackShowPictureDelegate?
	) {
		self.viewController = viewController
		self.backSceneHandler = backSceneHandler
	}

	// MARK: - Lifecycle
	private weak var viewController: IShowPictureLogic?
}

extension ShowPicturePresenter: IShowPicturePresenter {
	func present(present: SPRequest) {
		switch present {
		case .success(let model):
			// Конвертируем модель для отображения.
			let modelViewModel = ShowPictureModel.ViewModel.ImageData(from: model)
			viewController?.renderImage(viewModel: modelViewModel)
		case .failure(let error):
			print("☠️ Error \(error)")
		}
	}

	func backToView() {
		backSceneHandler?.backToScene()
	}
}
