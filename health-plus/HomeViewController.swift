//
//  HomeViewController.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/02/28.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = data[row]
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    var samplepickerView = UIPickerView()
    var data = ["Orange", "Grape", "Banana", "grape"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
    }
    
    func createPickerView() {
        samplepickerView.delegate = self
        textField.inputView = samplepickerView
        // toolbar
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(HomeViewController.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        textField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.endEditing(true)
    }
}
