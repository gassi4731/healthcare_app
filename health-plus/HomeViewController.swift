//
//  HomeViewController.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import UIKit

class HomeViewController: UIViewController{
    
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
