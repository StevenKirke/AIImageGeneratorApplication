//
//  Extension+UIColor.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import UIKit

extension UIColor {
	static func color(light: UIColor, dark: UIColor) -> UIColor {
		if #available(iOS 13, *) {
			return .init { traitCollection in
				return traitCollection.userInterfaceStyle == .dark ? dark : light
			}
		} else {
			return light
		}
	}
}

extension UIColor {
	convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
		self.init(
			red: CGFloat(red) / 255.0,
			green: CGFloat(green) / 255.0,
			blue: CGFloat(blue) / 255.0,
			alpha: CGFloat(alpha) / 255.0
		)
	}

	convenience init(hex: Int) {
		if hex > 0xffffff {
			self.init(
				red: UInt8((hex >> 24) & 0xff),
				green: UInt8((hex >> 16) & 0xff),
				blue: UInt8((hex >> 8) & 0xff),
				alpha: UInt8(hex & 0xff)
			)
		} else {
			self.init(
				red: UInt8((hex >> 16) & 0xff),
				green: UInt8((hex >> 8) & 0xff),
				blue: UInt8(hex & 0xff)
			)
		}
	}

	convenience init(hex: String) {
		var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
		let hex = Int(hexSanitized, radix: 16) ?? 0
		self.init(hex: Int(hex))
	}
}
