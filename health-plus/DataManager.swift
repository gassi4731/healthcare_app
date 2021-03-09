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
    
    class func update(key: String, eat: EatData?, run: RunData?, task: Int?) -> Bool {
        let registerData:HealthData = get(key: key) ?? HealthData(eat: nil, run: nil)
        
        var eatArray: Array<EatData>
        var runArray: Array<RunData>
        var taskArray: Array<Int> = registerData.finishTask
        
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
        if task != nil {
            taskArray.append(task!)
        }
        
        return uploadDB(key: key, eatArray: eatArray, runArray: runArray, taskArray: taskArray)
    }
    
    class func delete(key: String, data: String, index: Int) {
        guard let registerData: HealthData = get(key: key) else {
            return
        }
        let eatArray: Array<EatData> = registerData.eat ?? []
        let runArray: Array<RunData> = registerData.run ?? []
        let taskArray: Array<Int> = registerData.finishTask
        
        if data == "eat" {
            var editData: Array<EatData> = registerData.eat!
            editData.remove(at: index)
            uploadDB(key: key, eatArray: editData, runArray: runArray, taskArray: taskArray)
        } else if data == "run" {
            var editData: Array<RunData> = registerData.run!
            editData.remove(at: index)
            uploadDB(key: key, eatArray: eatArray, runArray: editData, taskArray: taskArray)
        } else if data == "task" {
            var editData: Array<Int> = registerData.finishTask
            editData.removeAll(where: { $0 == index})
            uploadDB(key: key, eatArray: eatArray, runArray: runArray, taskArray: editData)
        }
        return
    }
    
    class func uploadDB(key: String, eatArray: Array<EatData>, runArray: Array<RunData>, taskArray: Array<Int>) -> Bool {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        // HealthDataに格納
        let updateData = HealthData(eat: eatArray, run: runArray, finishTask: taskArray)
        
        // UserDefaultにアップロード
        guard let encodeData = try? jsonEncoder.encode(updateData) else {
            print("Error: encodeData")
            return false
        }
        UserDefaults.standard.set(encodeData, forKey: key)
        return true
    }
}
