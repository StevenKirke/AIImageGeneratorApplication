//
//  Extension+UIImage.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 29.02.2024.
//

import UIKit

extension UIImage {
	/// Изменение размера изображения.
	func resized(to size: CGSize) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image { _ in
			draw(in: CGRect(origin: .zero, size: size))
		}
	}
}
