//
//  DataManager.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/03/06.
//

import Foundation

class DataManager {
    
    class func get(key: String) -> HealthData? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let registerData = UserDefaults.standard.data(forKey: key),
              let decodeData = try? jsonDecoder.decode(HealthData.self, from: registerData)  else {
            print("get return nil")
            return nil
        }
        return decodeData
    }
    
    class func update(key: String, eat: EatData?, run: RunData?) -> Bool {
        let jsonEncoder = JSONEncoder()
        var eatArray: Array<EatData>
        var runArray: Array<RunData>
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        
        let registerData:HealthData = get(key: key) ?? HealthData(eat: nil, run: nil)
        
        // 既に登録されているものを追加
        if registerData.eat != nil {
            eatArray = registerData.eat!
        } else {
            eatArray = []
        }
        
        if registerData.run != nil {
            runArray = registerData.run!
        } else {
            runArray = []
        }
        
        // 新規で追加するものを登録
        if eat != nil {
            eatArray.append(eat!)
        }
        if run != nil {
            runArray.append(run!)
        }
        
        // HealthDataに格納
        let updateData = HealthData(eat: eatArray, run: runArray)
        
        // UserDefaultにアップロード
        guard let encodeData = try? jsonEncoder.encode(updateData) else {
            print("Error: encodeData")
            return false
        }
        UserDefaults.standard.set(encodeData, forKey: key)
        return true
    }
}
