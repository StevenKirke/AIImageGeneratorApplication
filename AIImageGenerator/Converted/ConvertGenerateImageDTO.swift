//
//  ConvertGenerateImageDTO.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import Foundation

protocol IConvertGenerateImageDTO: AnyObject {
	/// КОнвертация модели GenerateImageDTO в формат URL или ошибка.
	func convertDTO(modelDTO: GenerateImageDTO, resultConvert: (Result<URL, ErrorConvert>) -> Void)
}

enum ErrorConvert: Error {
	/// Ошибка, конвертации URL.
	case errorConvertURL
	/// Ошибка, нет изображения.
	case errorEmptyImage
	/// Ошибка, в теле JSON, поле message не пустое.
	case errorWithResponse(String)

	var title: String {
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

final class ConvertGenerateImageDTO: IConvertGenerateImageDTO {
	func convertDTO(modelDTO: GenerateImageDTO, resultConvert: (Result<URL, ErrorConvert>) -> Void) {
		switch modelDTO.status {
		case .success:
			guard let firstElement = modelDTO.output?.first else {
				resultConvert(.failure(.errorEmptyImage))
				return
			}
			guard let url = URL(string: firstElement) else {
				resultConvert(.failure(.errorConvertURL))
				return
			}
			resultConvert(.success(url))
		case .error:
			if let error = modelDTO.messege {
				resultConvert(.failure(.errorWithResponse(error)))
				return
			}
		}
	}
}
