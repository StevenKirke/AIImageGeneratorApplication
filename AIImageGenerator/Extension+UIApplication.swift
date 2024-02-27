//
//  Extension+UIApplication.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import UIKit

extension UIApplication {
	/// Скрываем клавиатуру.
	func endEditing() {
		sendAction(
			#selector(UIResponder.resignFirstResponder),
			to: nil,
			from: nil,
			for: nil
		)
	}
}
