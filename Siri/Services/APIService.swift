//
//  APIService.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 21/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

// MARK: - API Service
struct APIService {

    static let headers = [
        "x-app-id": Constant.nutritionixAppId,
        "x-app-key": Constant.nutritionixAppKey
    ]

    static func verifyFoodCalories(_ text: String,
                                   context: NSManagedObjectContext,
                                   _ completion: @escaping (DefaultResult<[Food]>) -> Void) {
        Alamofire.request(Constant.nutritionixURL,
                          method: .post,
                          parameters: ["query": text],
                          headers: APIService.headers).validate().responseJSON { response in

            switch response.result {
            case .success(let result):
                guard let json = result as? [String: Any] else { return }
                guard let foods = json["foods"] as? [[String: Any]] else { return }
                Food.importList(foods, backgroundContext: context, completion: { importResult in

                    switch importResult {
                    case .success(result: let foodList):
                        completion(DefaultResult.success(result: foodList))

                    case .failure(error: let error):
                        completion(DefaultResult.failure(error: error))
                    }
                })

            case .failure(let error):
                print(error)
            }
        }
    }
}
