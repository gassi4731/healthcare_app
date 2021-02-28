//
//  DataStructure.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import Foundation

struct HealthData: Codable {
    let date: Date
    let eat: Array<EatData>
    let run: Array<RunData>
    let name: String?
    let description: String?
}

struct EatData: Codable {
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
