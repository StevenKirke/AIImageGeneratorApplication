//
//  NetworkKingfisherManager.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 28.02.2024.
//

import Foundation
import Kingfisher

protocol INetworkKingfisherManager: AnyObject {
	/// Метод запроса изображения.
	///	- Parameters:
	///		- url: URL для получения изображения.
	///	- Returns: Возвращает Data, или ошибку получения изображения.
	func getImage(url: URL, returnModel: @escaping (Result<Data, ErrorResponseWithKingfisher>) -> Void)
}

// Описание ошибок.
enum ErrorResponseWithKingfisher: LocalizedError {
	/// Ошибка, конвертации Data.
	case errorConvertData
	case kingfisherError(Error)

	var errorDescription: String? {
		var textError = ""
		switch self {
		case .errorConvertData:
			textError = "Invalid convert DATA!"
		case .kingfisherError(let kingfisher):
			textError = "Invalid work Kingfisher! \(kingfisher.localizedDescription)"
		}
		return textError
	}
}

final class NetworkKingfisherManager: INetworkKingfisherManager {
	func getImage(
		url: URL, returnModel: @escaping (Result<Data, ErrorResponseWithKingfisher>) -> Void
	) {
		KingfisherManager.shared.retrieveImage(with: url) { result in
			switch result {
			case .success(let image):
				let data = image.data()
				guard let currentData = data else {
					returnModel(.failure(.errorConvertData))
					return
				}
				returnModel(.success(currentData))
			case .failure(let error):
				returnModel(.failure(.kingfisherError(error)))
			}
		}
	}

}

