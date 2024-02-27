//
//  GenerateImageWorker.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import Foundation

protocol IGenerateImageWorker: AnyObject {
	/**
	 Запрос, на получение данных.
	 - Parameters:
			- prompt: Текст для запроса.
	 */
	func getData<T: Decodable>(
		prompt: MainSearchViewModel.Response.ImageData, modelDTO: T.Type, request: @escaping (Result<T, Error>) -> Void
	)
}

final class GenerateImageWorker {
	// MARK: - Public properties

	// MARK: - Dependencies
	let assemblerURL: IAssemblerURLService?
	let networkManager: INetworkManager?
	let decodeJSONManager: IDecodeJsonManager?

	// MARK: - Initializator
	init(
		assemblerURL: IAssemblerURLService?,
		networkManager: INetworkManager?,
		decodeJSONManager: IDecodeJsonManager?
	) {
		self.assemblerURL = assemblerURL
		self.networkManager = networkManager
		self.decodeJSONManager = decodeJSONManager
	}
}

extension GenerateImageWorker: IGenerateImageWorker {
	func getData<T: Decodable>(
		prompt: MainSearchViewModel.Response.ImageData, modelDTO: T.Type, request: @escaping (Result<T, Error>) -> Void
	) {
		fetch(prompt: prompt, modelDTO: modelDTO) { requestData in
			switch requestData {
			case .success(let jsonDTO):
				request(.success(jsonDTO))
			case .failure(let error):
				print("Ошибка запроса или декодирования JSON!")
				request(.failure(error))
			}
		}
	}
}

// MARK: - NetworkManager.
private extension GenerateImageWorker {
	func fetch<T: Decodable>(
		prompt: MainSearchViewModel.Response.ImageData, modelDTO: T.Type, request: @escaping (Result<T, Error>) -> Void
	) {
		// Сборка URL для запроса изображения.
		let assemblerURL = assemblerURL?.assemblerUlRsImage(prompt: prompt)
		guard let url = assemblerURL else {
			return
		}
		// Сетевой запрос.
		networkManager?.getDataPOST(url: url.absoluteString, returnModel: { resultData in
		switch resultData {
			case .success(let data):
				self.decode(data: data, model: modelDTO.self) { json in
					// Возвращаем JSON вместе с ошибкой.
					request(json)
				}
			case .failure(let error):
				// Какая либо ошибка с сетевого запроса.
				print("Ошибка сетевого запроса!")
				request(.failure(error))
			}
		})
	}
}

// MARK: - Decode JSON.
private extension GenerateImageWorker {
	// Возвращаем декодированную модель или ошибку.
	func decode<T: Decodable>(data: Data, model: T.Type, request: @escaping (Result<T, Error>) -> Void) {
		decodeJSONManager?.decodeJSON(data: data, model: model.self) { resultJSON in
			switch resultJSON {
			case .success(let json):
				// Возвращаем JSON.
				request(.success(json))
			case .failure(let error):
				// Ошибка декодирования.
				print("Ошибка декодирования JSON!")
				request(.failure(error))
			}
		}
	}
}
