//
//  APIService.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 21/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import Foundation
import Alamofire


// MARK: - API Service
struct APIService {

    static let headers = [
        "x-app-id": Constant.nutritionixAppId,
        "x-app-key": Constant.nutritionixAppKey
    ]

    static func verifyFoodCalories(_ text: String) {
        Alamofire.request(Constant.nutritionixURL, method: .post, parameters: ["query": text], headers: APIService.headers).validate().responseJSON { response in
            switch response.result {
            case .success(let result):
                guard let json = result as? [String: Any] else { return }
                guard let foods = json["foods"] as? [[String: Any]] else { return }
                for food in foods {
                    print("\n\n")
                    print(food["food_name"])
                    print(food["serving_qty"])
                    print(food["serving_unit"])
                    print(food["serving_weight_grams"])
                    print(food["nf_calories"])
                    print(food["nf_total_fat"])
                    print(food["nf_total_carbohydrate"])
                    print(food["nf_protein"])
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
