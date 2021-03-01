//
//  EatViewController.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import UIKit

class EatViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource {
    
    @IBOutlet weak var eatTable: UITableView!
    
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var more: UITextField!
    
    var genrePickerView = UIPickerView()
    var contentPickerView = UIPickerView()
    var morePickerView = UIPickerView()
    
    var typeText: String = "朝食"
    
    var eatViewData: Array<EatData> = []
    
    var genreData = ["ご飯定食類", "めん類", "パン類", "菓子・デザート類", "ドリンク類", "単品料理"]
    var contentData = ["sample1", "sample2", "sample3"]
    var moreData = ["100", "200", "300"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "食事を記録"
        
        createPickerView()
        eatTable.dataSource = self
        
        eatViewData.append(EatData(type: "朝食", genre: "ごはん", content: "ごはん", more: "", cal: 100))
        eatViewData.append(EatData(type: "昼食", genre: "うどん", content: "うどん", more: "", cal: 100))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func register() {
        let genreText = genre.text ?? nil
        let contentText = content.text ?? nil
        let moreText = more.text ?? nil
        
        // 数が全て入っていない場合は、エラーを表示する
        if genreText == nil || contentText == nil || moreText == nil {
            alertShow(content: "すべての入力が終わると登録ができます！")
        } else {
            let calNum = 100 // カロリー計算をつくる
            let eatData = EatData(type: typeText,genre: genreText!, content: contentText!, more: moreText!, cal: calNum)
            
            print(eatData)
            update(eatData: eatData)
        }
    }
    
    //セグメントが変更されたときの処理
    @IBAction func segmentChanged(sender: AnyObject) {
        //選択されているセグメントのインデックス
        let selectedIndex = type.selectedSegmentIndex
        //選択されたインデックスの文字列を取得してラベルに設定
        typeText = type.titleForSegment(at: selectedIndex) ?? "朝食"
    }
    
    // UserDefaultの処理系
    func update(eatData: EatData) {
        let key = keyFromNowDate()
        var eatArray: Array<EatData>
        // UserDefaultから現在のデータを取得
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = UserDefaults.standard.data(forKey: key)
        if data != nil {
            guard let registerData = try? jsonDecoder.decode(HealthData.self, from: data!) else {
                alertShow(content: "既存データ読み取り時にエラーが発生しました。")
                return
            }
            if registerData.eat != nil {
                eatArray = registerData.eat!
                eatArray.append(eatData)
            } else {
                eatArray = [eatData]
            }
        } else {
            eatArray = [eatData]
        }
        let health = HealthData(eat: eatArray, run: nil)
        uploadUD(health: health, key: key)
    }
    
    // UserDefaultにアップロード
    func uploadUD(health: HealthData, key: String) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let uploadData = try? jsonEncoder.encode(health) else {
            return
        }
        UserDefaults.standard.set(uploadData, forKey: key)
    }
    
    // keyになる今日の日付を日付を返す
    func keyFromNowDate() -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        let nowMixString = f.string(from: now)
        let nowSplitNum = (nowMixString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)).joined()
        return nowSplitNum
    }
    
    // エラーを表示
    func alertShow(content: String) {
        let alert = UIAlertController(title: "エラー", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // テーブル関連の処理
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eatViewData.count
    }
    
    // セルの中に表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EatTableViewCell", for: indexPath) as! EatTableViewCell
        tableView.separatorInset = .zero
        
        cell.setup(type: eatViewData[indexPath.row].type, content: eatViewData[indexPath.row].content, cal: String(eatViewData[indexPath.row].cal))
        
        return cell
    }
    
    
//    func updateLabel() {
//        let jsonDecoder = JSONDecoder()
//        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//        guard let data = UserDefaults.standard.data(forKey: "key"),
//              let monster = try? jsonDecoder.decode(Sample.self, from: data) else {
//            return
//        }
//        label.text = monster.name
//        label2.text = monster.description
//    }
    
    // ピッカー系の処理
    // 縦列の並び
    func numberOfComponents(in genrePickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 何個存在するか
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerView {
            return genreData.count
        } else if pickerView == contentPickerView {
            return contentData.count
        } else {
            return moreData.count
        }
    }
    
    // それぞれに値を代入
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerView {
            return genreData[row]
        } else if pickerView == contentPickerView {
            return contentData[row]
        } else {
            return moreData[row]
        }
    }
    
    // 選択した値を入手
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePickerView {
            genre.text = genreData[row]
        } else if pickerView == contentPickerView {
            content.text = contentData[row]
        } else {
            more.text = moreData[row]
        }
        
    }
    
    func createPickerView() {
        genrePickerView.delegate = self
        contentPickerView.delegate = self
        morePickerView.delegate = self
        genre.inputView = genrePickerView
        content.inputView = contentPickerView
        more.inputView = morePickerView
        // toolbar
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EatViewController.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        genre.inputAccessoryView = toolbar
        content.inputAccessoryView = toolbar
        more.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        genre.endEditing(true)
        content.endEditing(true)
        more.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        genre.endEditing(true)
        content.endEditing(true)
        more.endEditing(true)
    }
}
