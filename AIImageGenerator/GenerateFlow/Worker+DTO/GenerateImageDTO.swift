//
//  GenerateImageDTO.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import Foundation

struct GenerateImageDTO: Decodable {
	let status: StatusDTO
	let messege: String?
	let message: String?
	let output: [String]?
}

enum StatusDTO: String, Codable {
	case success
	case error
}

