//
//  HomeViewController.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import UIKit
import Charts

private let ITEM_COUNT = 12

class HomeViewController: UIViewController{
    
    @IBOutlet weak var chartView: CombinedChartView!
    @IBOutlet weak var taskTable: UITableView!
    
    // 初期値
    var taskViewData: Array<TaskData> = []
    
    // 今日の日付をKeyにする
    let key: String = Method.keyFromNowDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ホーム"
        
        taskTable.dataSource = self
        taskTable.delegate = self
        updateTableData()
        
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.legend.enabled = false
        setChartData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setChartData()
    }
    
    func updateTableData() {
        taskViewData = []
        let registerData = DataManager.get(key: key)?.finishTask ?? []
        for (index, text) in taskData.enumerated() {
            var addData: TaskData!
            if registerData.firstIndex(of: index) != nil {
                addData = TaskData(taskId: index, text: text, isDone: true)
            } else {
                addData = TaskData(taskId: index, text: text, isDone: false)
            }
            taskViewData.append(addData)
        }
        taskViewData.sort { !$0.isDone && $1.isDone }
    }
    
    func setChartData() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
//        data.barData = generateBarData()
        
        chartView.xAxis.axisMaximum = data.xMax + 0.25
        
        chartView.data = data
    }
    
    func generateLineData() -> LineChartData {
        let entries = DataManager.getMonthData()
        
        let set = LineChartDataSet(entries: entries, label: "総合カロリー量")
        set.setColor(UIColor(named: "MainColor")!)
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(named: "MainColor")!)
        set.circleRadius = 3
        set.circleHoleRadius = 2.5
        set.drawValuesEnabled = false
        
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
//    func generateBarData() -> BarChartData {
//        let entries = (0..<ITEM_COUNT).map {
//            BarChartDataEntry(x: Double($0), y: sin(.pi * Double($0%128) / 64))
//        }
//
//        let set = BarChartDataSet(entries: entries, label: "Sinus Function")
//        set.setColor(UIColor(red: 240/255, green: 120/255, blue: 123/255, alpha: 1))
//
//        let data = BarChartData(dataSet: set)
//        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
//        data.setDrawValues(false)
//        data.barWidth = 0.8
//
//        return data
//    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskViewData.count
    }
    
    // セルの中に表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        tableView.separatorInset = .zero
        
        cell.setup(labelText: taskViewData[indexPath.row].text, image: taskViewData[indexPath.row].isDone)
        return cell
    }
    
    // タップされたときの挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isBool: Bool = taskViewData[indexPath.row].isDone
        let id: Int = taskViewData[indexPath.row].taskId
        if isBool {
            DataManager.delete(key: key, data: "task", index: id)
        } else {
            DataManager.update(key: key, eat: nil, run: nil, task: id)
        }
        updateTableData()
        tableView.reloadData()
    }
}


struct TaskData: Codable {
    let taskId: Int
    let text: String
    var isDone: Bool = false
}
