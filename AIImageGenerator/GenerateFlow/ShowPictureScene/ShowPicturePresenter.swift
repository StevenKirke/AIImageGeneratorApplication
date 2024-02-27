//
//  ShowPicturePresenter.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import Foundation

protocol IShowPicturePresenter: AnyObject {
	func present(present: SPRequest)
}

final class ShowPicturePresenter {
	// MARK: - Private properties

	// MARK: - Initializator
	init(viewController: IShowPictureLogic?) {
		self.viewController = viewController
	}

	// MARK: - Lifecycle
	private weak var viewController: IShowPictureLogic?
}

extension ShowPicturePresenter: IShowPicturePresenter {
	func present(present: SPRequest) {
		switch present {
		case .success(let model):
			let model = ShowPictureModel.ViewModel.ImageURL(from: model)
			viewController?.renderImage(viewModel: model)
		case .failure(let error):
			print("Error \(error)")
		}
	}
}
