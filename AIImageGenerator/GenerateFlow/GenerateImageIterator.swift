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
	var worker: IGenerateImageWorker?
	var presenter: IGenerateImagePresenter?
	let converterDTO: IConvertGenerateImageDTO?

	// MARK: - Initializator
	init(
		worker: IGenerateImageWorker?,
		presenter: IGenerateImagePresenter?,
		converterDTO: IConvertGenerateImageDTO?
	) {
		self.worker = worker
		self.presenter = presenter
		self.converterDTO = converterDTO
	}
}

// MARK: - Fetch DATA.
extension GenerateImageIterator: IGenerateImageIterator {
	func fetch(responsePrompt: MSResponse) {
		switch responsePrompt {
		case .success(let prompt):
				worker?.getData(prompt: prompt, modelDTO: GenerateImageDTO.self) { resultData in
				switch resultData {
				case .success(let modelDTO):
					self.convertDTO(modelDTO: modelDTO)
				case .failure(let error):
					self.presenter?.present(present: .failure(error))
				}
			}
		}
	}
}
// MARK: - Convert DTO.
private extension GenerateImageIterator {
	func convertDTO(modelDTO: GenerateImageDTO) {
		converterDTO?.convertDTO(modelDTO: modelDTO) { resultConvert in
			switch resultConvert {
			case .success(let modelRequest):
				self.presenter?.present(present: .success(.init(from: modelRequest)))
			case .failure(let error):
				self.presenter?.present(present: .failure(error))
			}
		}
	}
}
