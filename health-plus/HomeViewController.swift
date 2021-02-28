//
//  HomeViewController.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import UIKit

class HomeViewController: UIViewController{
    
    @IBOutlet var label: UILabel!
    @IBOutlet var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ホーム"
        updateLabel()
    }
    @IBAction func set() {
        let monster = Sample(name: "uhooi", description: "ゆかいな　みどりの　せいぶつ。")
        // `JSONEncoder` で `Data` 型へエンコードし、UserDefaultsに追加する
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(monster) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "key")
        updateLabel()
    }
    
    @IBAction func update1() {
        let monster = Sample(name: nil, description: nil)
        // `JSONEncoder` で `Data` 型へエンコードし、UserDefaultsに追加する
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(monster) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "key")
        updateLabel()
    }
    
    @IBAction func update2() {
        updaterTest(name: "sample", description: nil)
        updateLabel()
    }
    
    func updateLabel() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: "key"),
              let monster = try? jsonDecoder.decode(Sample.self, from: data) else {
            return
        }
        label.text = monster.name
        label2.text = monster.description
    }
    
    func updaterTest(name: String?, description: String?) {
        var updateName: String
        var updateDescription: String
        
        // UserDefaultから現在のデータを取得
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        print(type(of: UserDefaults.standard.data(forKey: "key")))
        guard let data = UserDefaults.standard.data(forKey: "key"),
              let nowData = try? jsonDecoder.decode(Sample.self, from: data) else {
            return
        }
        
        // 差分のみを検出
        if name != nil {
            updateName = name!
        } else {
            updateName = nowData.name ?? ""
        }
        
        if description != nil {
            updateDescription = description!
        } else {
            updateDescription = nowData.description ?? ""
        }
        
        // UserDefaultにアップロード
        let sampleData = Sample(name: updateName, description: updateDescription)
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data2 = try? jsonEncoder.encode(sampleData) else {
            return
        }
        UserDefaults.standard.set(data2, forKey: "key")
    }
    
//    func HealthToUdEncoder(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    
    func UdToHealthEncoder(data: Data) throws -> HealthData {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let health = try? jsonDecoder.decode(HealthData.self, from: data) else {
            throw NSError(domain: "encode error", code: -1, userInfo: nil)
        }
        return health
    }
}

