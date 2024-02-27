//
//  FontStyle.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import UIKit

/// Кастомные шрифты, используемые в проекте.
enum FontsStyle {
	/// SFProDisplaySemibold
	case semiboldSF(CGFloat)

	var font: UIFont {
		var font = ""
		var fontSize: CGFloat = 0
		switch self {
		case .semiboldSF(let size):
			font = "SFProDisplay-Semibold"
			fontSize = size
		}
		return UIFont(name: font, size: fontSize)!
	}
}
