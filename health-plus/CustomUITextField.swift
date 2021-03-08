//
//  CustomUITextField.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/03/09.
//

import UIKit

class CustomUITextField: UITextField {
    
    //入力したテキストの余白
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5.0, dy: 0.0)
    }
    
    //編集中のテキストの余白
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5.0, dy: 0.0)
    }
    
    // 下線用のUIViewを作っておく
    let underline: UIView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        composeUnderline() // 下線のスタイルセットおよび追加処理
    }
    
    private func composeUnderline() {
        self.underline.frame = CGRect(
            x: 0,                    // x, yの位置指定は親要素,
            y: self.frame.height,    // この場合はCustomTextFieldを基準にする
            width: self.frame.width,
            height: 0.5)
        
        self.underline.backgroundColor = UIColor(named: "MainColor")
        
        self.addSubview(self.underline)
        self.bringSubviewToFront(self.underline)
    }
    
}
