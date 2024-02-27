//
//  AssemblerURLService.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import Foundation

protocol IAssemblerURLService: AnyObject {
	/// Сборщик URL для запроса изображения.
	func assemblerUlRsImage(prompt: MainSearchViewModel.Response.ImageData) -> URL?
}

/// Сборщик URL.
final class AssemblerURLService: IAssemblerURLService {
	/// Сборщик URL для запроса изображения, "stablediffusionapi.com".
	/// - Parameters:
	///		- prompt: Текст для запроса изображения.
	func assemblerUlRsImage(prompt: MainSearchViewModel.Response.ImageData) -> URL? {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "stablediffusionapi.com"
		components.path = "/api/v3/text2img"
		components.queryItems = [
			 URLQueryItem(name: "key", value: "TouFyL4VyhWWNhqC3DnF5hAdR2fLXxgGY4Gpe4BqC8YGKE2j4NjuNrJAXetE"),
			 URLQueryItem(name: "width", value: "512"),
			 URLQueryItem(name: "height", value: "512"),
			 URLQueryItem(name: "samples", value: "1"),
			 URLQueryItem(name: "prompt", value: prompt.prompt)
		 ]
		return components.url
	}
}
