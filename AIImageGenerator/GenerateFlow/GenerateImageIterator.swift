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
	/// Запрос на получение изображения.
	/// - Parameters:
	///		- urlImage: URL изображения.
	func fetchImage(urlImage: URL)
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
					self.convertDTO(modelDTO: modelDTO) { url in
						self.fetchImage(urlImage: url)
					}
				case .failure(let error):
					self.presenter?.present(present: .failure(error))
				}
			}
		}
	}

	func fetchImage(urlImage: URL) {
		worker?.getImageData(url: urlImage) { resultImage in
			switch resultImage {
			case .success(let image):
				// Конвертируем полученные данные для Presenter.
				let modelRequest = MainSearchViewModel.Request.ImageData(from: image)
				self.presenter?.present(present: .success(modelRequest))
			case .failure(let error):
				self.presenter?.present(present: .failure(error))
			}
		}
	}
}
// MARK: - Convert DTO.
private extension GenerateImageIterator {
	func convertDTO(modelDTO: GenerateImageDTO, resultURL: (URL) -> Void) {
		converterDTO?.convertDTO(modelDTO: modelDTO) { resultConvert in
			switch resultConvert {
			case .success(let modelRequest):
				resultURL(modelRequest)
			case .failure(let error):
				self.presenter?.present(present: .failure(error))
			}
		}
	}
}
