//
//  ShowPicturePresenter.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import Foundation

protocol IShowPicturePresenter: AnyObject {
	func present(present: SPResponse)
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
	func present(present: SPResponse) {
		switch present {
		case .needShowImage(let imageData):
			let viewModel = ShowPictureModel.ViewModel(imageData: imageData)
			viewController?.renderImage(viewModel: viewModel)
		case .successSaveImage:
			handlerMassage("")
		case .failureSaveImage(let error):
			handlerMassage(error.localizedDescription)
		}
	}

	func backToView() {
		backSceneHandler?.backToScene()
	}

	private func handlerMassage(_ message: String) {
		viewController?.showSaveImage()
	}
}
