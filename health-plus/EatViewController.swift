//
//  EatViewController.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import UIKit

class EatViewController: UIViewController {
    
    @IBOutlet weak var eatTable: UITableView!
    
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var content: UITextField!
    
    private var genrePickerView = UIPickerView()
    private var contentPickerView = UIPickerView()
    
    // 初期値
    var typeText: String = "朝食"
    var eatViewData: Array<EatData> = []
    var genreRow: Int!
    var contentRow: Int!
    
    // 今日の日付をKeyにする
    let key: String = Method.keyFromNowDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "食事を記録"
        
        eatTable.dataSource = self
        
        createPickerView()
        genrePickerView.delegate = self
        genrePickerView.dataSource = self
        contentPickerView.delegate = self
        contentPickerView.dataSource = self
        
        updateEatTable()
    }
    
    @IBAction func register() {
        let genreText: String = genre.text ?? ""
        let contentText: String = content.text ?? ""
        
        // 数が全て入っていない場合は、エラーを表示する
        if Method.empty(genreText) && Method.empty(contentText) {
            Alert.show(title: "エラー", content: "すべての入力が終わると登録ができます！", viewController: self)
        } else {
            let calNum = calEatData[String(genreRow)]![contentRow]
            let eatData = EatData(type: typeText,genre: genreText, content: contentText, cal: Double(calNum))
            
            if !DataManager.update(key: key, eat: eatData, run: nil, task: nil) {
                Alert.show(title: "エラー", content: "書き込みエラーが発生しました。", viewController: self)
                return
            }
            updateEatTable()
            initInput()
        }
    }
    
    //セグメントが変更されたときの処理
    @IBAction func segmentChanged(sender: AnyObject) {
        //選択されているセグメントのインデックス
        let selectedIndex = type.selectedSegmentIndex
        //選択されたインデックスの文字列を取得してラベルに設定
        typeText = type.titleForSegment(at: selectedIndex) ?? "朝食"
    }
    
    // 入力内容初期化
    private func initInput() {
        genre.text = ""
        content.text = ""
    }
    
    // テーブルの内容を更新
    private func updateEatTable() {
        eatViewData = []
        let eatData = DataManager.get(key: key)?.eat ?? []
        eatData.forEach{ eatViewData.append($0) }
        eatViewData.reverse()
        self.eatTable.reloadData()
    }
}

extension EatViewController: UITableViewDataSource {
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eatViewData.count
    }
    
    // セルの中に表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EatTableViewCell", for: indexPath) as! CustomTableViewCell
        tableView.separatorInset = .zero
        
        let typeAndContent: String = eatViewData[indexPath.row].content + " （" + eatViewData[indexPath.row].type + "）"
        let cal: String = String(ceil(eatViewData[indexPath.row].cal * 10) / 10) + " Kcal"
        cell.setup(typeAndContent: typeAndContent, cal: cal)
        
        return cell
    }
    
    // セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            eatViewData.remove(at: indexPath.row)
            DataManager.delete(key: key, data: "eat", index: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension EatViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerView {
            return genreEatData.count
        } else {
            return contentEatData[String(genreRow)]!.count
        }
    }
    
    // 内容を入れていく
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerView {
            return genreEatData[row]
        } else {
            return contentEatData[String(genreRow)]![row]
        }
    }
    
    // 選択した値を入手
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePickerView {
            genre.text = genreEatData[row]
            genreRow = row
            controlPicerView()
        } else {
            content.text = contentEatData[String(genreRow)]![row]
            contentRow = row
            controlPicerView()
        }
    }
    
    private func createPickerView() {
        genrePickerView.delegate = self
        contentPickerView.delegate = self
        genre.inputView = genrePickerView
        content.inputView = contentPickerView
        content.isEnabled = false
        // toolbar
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EatViewController.donePicker))
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
    }
}
