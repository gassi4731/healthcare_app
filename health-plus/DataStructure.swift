//
//  DataStructure.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import Foundation

struct HealthData: Codable {
    var eat: Array<EatData>?
    var run: Array<RunData>?
}

struct EatData: Codable {
    let type: String
    let genre: String
    let content: String
    let more: String
    let cal: Int
}

struct RunData: Codable {
    let genre: String
    let content: String
    let more: String
    let time: Int
    let cal: Int
}

let genreData = ["ご飯類", "定食類", "めん類", "パン類", "菓子・デザート類", "ドリンク類", "単品料理"]
//let contentData = ["0": ["ごはん", "玄米", "おかゆ", "もち", "おにぎり"], "1": ["すき焼き定食", "とんかつ定食", "生姜焼き定食", "天ぷら定食", "ひれかつ定食", "アジフライ定食", "サバ味噌定食", "鰤照り焼き定食", "さんま塩焼き定食", "刺身定食", "ミックスフライ定食", "ハンバーグ定食", "レベニラ定食", "麻婆豆腐定食", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]]
