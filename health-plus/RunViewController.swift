//
//  RunViewController.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import UIKit

class RunViewController: UIViewController {
    
    @IBOutlet weak var runTable: UITableView!
    
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var time: UITextField!
    
    var genrePickerView = UIPickerView()
    var contentPickerVIew = UIPickerView()
    
    // 初期値
    var runViewData: Array<RunData> = []
    var genreRow: Int!
    var contentRow: Int!
    var weight: Double = 45
    
    // 今日の日付をKeyにする
    let key: String = Method.keyFromNowDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "運動を記録"
        
        runTable.dataSource = self
        updateRunTable()
        
        createPickerView()
        genrePickerView.delegate = self
        genrePickerView.dataSource = self
        contentPickerVIew.delegate = self
        contentPickerVIew.dataSource = self
        
        weight = UserDefaults.standard.double(forKey: "weight")
    }
    
    @IBAction func register() {
        let genreText: String = genre.text ?? ""
        let contentText: String = content.text ?? ""
        let timeText: String = time.text ?? ""
        
        // 数が入っていない場合は、エラーを表示する
        if Method.empty(genreText) && Method.empty(contentText) && Method.empty(timeText) {
            Alert.show(title: "エラー", content: "すべての入力が終わると登録ができます！", viewController: self)
        } else {
            let calNum: Double = calRunData[String(genreRow)]![contentRow] * Double(timeText)! * weight
            let runData = RunData(genre: genreText, content: contentText, time: Int(timeText)!, cal: calNum)
            if !DataManager.update(key: key, eat: nil, run: runData, task: nil) {
                Alert.show(title: "エラー", content: "書き込みエラーが発生しました。", viewController: self)
                return
            }
            updateRunTable()
            initInput()
        }
    }
    
    // 入力内容初期化
    private func initInput() {
        genre.text = ""
        content.text = ""
        time.text = ""
    }
    
    // テーブルの内容を更新
    private func updateRunTable() {
        runViewData = []
        let runData = DataManager.get(key: key)?.run ?? []
        runData.forEach{ runViewData.append($0) }
        runViewData.reverse()
        self.runTable.reloadData()
    }
}

extension RunViewController: UITableViewDataSource {
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runViewData.count
    }
    
    // セルの中に表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunTableViewCell", for: indexPath) as! CustomTableViewCell
        tableView.separatorInset = .zero
        
        let typeAndContent: String = runViewData[indexPath.row].content + " （" + String(runViewData[indexPath.row].time) + "分）"
        let cal: String = String(ceil(runViewData[indexPath.row].cal * 10) / 10) + " Kcal"
        cell.setup(typeAndContent: typeAndContent, cal: cal)
        
        return cell
    }
    
    // セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            runViewData.remove(at: indexPath.row)
            DataManager.delete(key: key, data: "run", index: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}


extension RunViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 何個存在するか
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerView {
            return genreRunData.count
        } else {
            return contentRunData[String(genreRow)]!.count
        }
    }
    
    // 内容を入れていく
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerView {
            return genreRunData[row]
        } else {
            return contentRunData[String(genreRow)]![row]
        }
    }
    
    // 選択した値を入手
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePickerView {
            genre.text = genreRunData[row]
            genreRow = row
            controlPicerView()
        } else {
            content.text = contentRunData[String(genreRow)]![row]
            contentRow = row
            controlPicerView()
        }
    }
    
    private func createPickerView() {
        genrePickerView.delegate = self
        contentPickerVIew.delegate = self
        genre.inputView = genrePickerView
        content.inputView = contentPickerVIew
        content.isEnabled = false
        time.isEnabled = false
        // toolbar
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(RunViewController.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        genre.inputAccessoryView = toolbar
        content.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        genre.endEditing(true)
        content.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        genre.endEditing(true)
        content.endEditing(true)
    }
    
    // 使えるか使えないかの制御
    private func controlPicerView() {
        if !Method.empty(genre.text) {
            content.isEnabled = true
        } else {
            content.isEnabled = false
        }
        
        if !Method.empty(content.text) {
            time.isEnabled = true
        } else {
            time.isEnabled = false
        }
    }
}
