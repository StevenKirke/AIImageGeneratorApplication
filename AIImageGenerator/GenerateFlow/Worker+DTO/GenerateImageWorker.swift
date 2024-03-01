//
//  ConvertGenerateImageDTO.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import Foundation

enum ErrorConvert: Error {
	/// Ошибка, конвертации URL.
	case errorConvertURL
	/// Ошибка, нет изображения.
	case errorEmptyImage
	/// Ошибка, в теле JSON, поле message не пустое.
	case errorWithResponse(String)
}

extension ErrorConvert: LocalizedError {
	var errorDescription: String? {
		var textError = ""
		switch self {
		case .errorConvertURL:
			textError = "Invalid URL conversion."
		case .errorEmptyImage:
			textError = "Empty field output."
		case .errorWithResponse(let error):
			textError = "Invalid Request: \(error)"
		}
		return textError
	}
}

protocol IGenerateImageWorker: AnyObject {
	func fetch(responsePrompt: MSResponse, response: @escaping (Result<Data, Error>) -> Void)
}

final class GenerateImageWorker: IGenerateImageWorker {

	private let generateImageNetwork: IGenerateImageNetworkService

	init(generateImageNetwork: IGenerateImageNetworkService) {
		self.generateImageNetwork = generateImageNetwork
	}

	func fetch(responsePrompt: MSResponse, response: @escaping (Result<Data, Error>) -> Void) {
		switch responsePrompt {
		case .success(let prompt):
				generateImageNetwork.getData(prompt: prompt, modelDTO: GenerateImageDTO.self) { resultData in
				switch resultData {
				case .success(let modelDTO):
					self.convertDTO(modelDTO: modelDTO) { result in
						switch result {
						case .success(let url):
							self.generateImageNetwork.getImageData(url: url, responseImage: response)
						case .failure(let error):
							response(.failure(error))
						}
					}
				case .failure(let error):
					response(.failure(error))
				}
			}
		}
	}

	private func convertDTO(modelDTO: GenerateImageDTO, resultConvert: (Result<URL, Error>) -> Void) {
		switch modelDTO.status {
		case .success:
			guard let firstElement = modelDTO.output?.first else {
				resultConvert(.failure(ErrorConvert.errorEmptyImage))
				return
			}
			guard let url = URL(string: firstElement) else {
				resultConvert(.failure(ErrorConvert.errorConvertURL))
				return
			}
			resultConvert(.success(url))
		case .error:
			if let error = modelDTO.messege {
				resultConvert(.failure(ErrorConvert.errorWithResponse(error)))
				return
			}
			if let error = modelDTO.message {
				resultConvert(.failure(ErrorConvert.errorWithResponse(error)))
				return
			}
		}
	}
}
