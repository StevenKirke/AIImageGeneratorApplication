//
//  NetworkManager.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import Foundation

protocol INetworkManager {
	/// Метод сетевого запроса.
	func getDataPOST(url: String, returnModel: @escaping (Result<Data, ErrorResponse>) -> Void)
}

enum ErrorResponse: LocalizedError {
	/// Ошибка, конвертации URL.
	case errorConvertURL
	/// Ошибка, состояния ответа HTTP.
	case errorResponse
	/// Ошибка, запроса HTTP.
	case errorRequest(String)
	/// Пустая Data.
	case errorEmptyData

	var errorDescription: String? {
		var textError = ""
		switch self {
		case .errorConvertURL:
			textError = "Invalid URL conversion."
		case .errorResponse:
			textError = "Invalid Response received from the server."
		case .errorRequest(let error):
			textError = "Invalid Request -  \(error)"
		case .errorEmptyData:
			textError = "Invalid data empty."
		}
		return textError
	}
}

/// Класс для работы с сетевыми запросами.
final class NetworkManager: INetworkManager {

	// MARK: - Private properties
	private let task = URLSession.shared

	// MARK: - Public methods
	func getDataPOST(url: String, returnModel: @escaping (Result<Data, ErrorResponse>) -> Void) {
		guard let url = URL(string: url) else {
			returnModel(.failure(.errorConvertURL))
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let dataTask = task.dataTask(with: request) { data, response, error in
			DispatchQueue.main.async {
				if let currentError = error {
					returnModel(.failure(.errorRequest(currentError.localizedDescription)))
				}
				if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode != 200 {
					print("httpURLResponse \(httpURLResponse)")
				}
				guard let currentData = data else {
					returnModel(.failure(.errorEmptyData))
					return
				}
				returnModel(.success(currentData))
			}
		}
		dataTask.resume()
	}
}
