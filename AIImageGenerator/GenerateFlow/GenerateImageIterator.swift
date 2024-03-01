//
//  GenerateImageIterator.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import Foundation

protocol IGenerateImageIterator: AnyObject {
	/// Запрос данных с сети или другого источника.
	/// - Parameters:
	///		- iteratorText: Тип MainSearchViewModel.Response.
	///		При положительном результате запрос на данные.
	///		В случае пустого значения .failure, отправляем ошибку.
	func fetch(responsePrompt: MSResponse)
}

final class GenerateImageIterator {
	// MARK: - Dependencies
	private var worker: IGenerateImageWorker
	private var presenter: IGenerateImagePresenter

	// MARK: - Initializator
	init(
		worker: IGenerateImageWorker,
		presenter: IGenerateImagePresenter
	) {
		self.worker = worker
		self.presenter = presenter
	}
}

// MARK: - Fetch DATA.
extension GenerateImageIterator: IGenerateImageIterator {
	func fetch(responsePrompt: MSResponse) {
		worker.fetch(responsePrompt: responsePrompt) { result in
			switch result {
			case .success(let data):
				let model = MSRequest.success(MainSearchViewModel.Request.ImageData(data: data))
				self.presenter.present(present: model)
			case .failure(let error):
				let model = MSRequest.failure(error)
				self.presenter.present(present: model)
			}
		}
	}
}
