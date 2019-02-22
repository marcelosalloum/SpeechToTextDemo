//
//  Constants.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import Foundation

struct Constant {
    static let modelName: String = "Nutrition"
    static let languageRegion: String = "en-US"
    static let nutritionixAppId: String = "edcff291"
    static let nutritionixAppKey: String = "8bbd1cac55d208cfff9ab34eadf18650"
    static let nutritionixURL: String = "https://trackapi.nutritionix.com/v2/natural/nutrients"
}

// MARK: - Result Handling
/// Handles any kind of results
public enum DefaultResult<Value> {
    /// Handles success results
    case success(result: Value?)

    /// Handles failure results
    case failure(error: Error)
}
