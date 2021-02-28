//
//  DataStructure.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import Foundation

struct HealthData: Codable {
    let eat: Array<EatData>?
    let run: Array<RunData>?
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
