//
//  EatViewController.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import UIKit

class EatViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var more: UITextField!
    
    var genrePickerView = UIPickerView()
    var contentPickerView = UIPickerView()
    var morePickerView = UIPickerView()
    
    var genreData = ["ご飯定食類", "めん類", "パン類", "菓子・デザート類", "ドリンク類", "単品料理"]
    var contentData = ["sample1", "sample2", "sample3"]
    var moreData = ["100", "200", "300"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "食事を記録"
        createPickerView()
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in genrePickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerView {
            return genreData.count
        } else if pickerView == contentPickerView {
            return contentData.count
        } else {
            return moreData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerView {
            return genreData[row]
        } else if pickerView == contentPickerView {
            return contentData[row]
        } else {
            return moreData[row]
        }
    }
    
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
    
    @IBAction func register() {
        print(genre.text)
    }
}
