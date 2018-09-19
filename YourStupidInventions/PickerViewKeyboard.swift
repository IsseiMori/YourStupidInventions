//
//  PickerViewKeyboard.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/11/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit

class PickerViewKeyboard: UIButton {

    var delegate: PickerViewKeyboardDelegate!
    var pickerView: UIPickerView!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var data: Array<String> {
        return delegate.titlesOfPickerViewKeyboard(sender: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
    }
    
    @objc func didTouchUpInside(_ sender: UIButton) {
        becomeFirstResponder()
    }
    
    override var inputView: UIView? {
        pickerView = UIPickerView()
        pickerView.delegate = self
        let row = delegate.initSelectedRow(sender: self)
        pickerView.selectRow(row, inComponent: 0, animated: true)
        
        return pickerView
    }
    
    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = 12
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PickerViewKeyboard.cancelPicker))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PickerViewKeyboard.donePicker))
        
        let toolbarItems = [space, cancelItem, flexSpaceItem, doneButtonItem, space]
        
        toolbar.setItems(toolbarItems, animated: true)
        
        return toolbar
    }
    
    @objc func cancelPicker() {
        delegate.didCancel(sender: self)
    }
    
    @objc func donePicker() {
        // added selectedIndex
        delegate.didDone(sender: self, selectedData: data[pickerView.selectedRow(inComponent: 0)], selectedIndex: pickerView.selectedRow(inComponent: 0))
    }

}

extension PickerViewKeyboard: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}

protocol PickerViewKeyboardDelegate {
    func titlesOfPickerViewKeyboard(sender: PickerViewKeyboard) -> Array<String>
    func initSelectedRow(sender: PickerViewKeyboard) -> Int
    func didCancel(sender: PickerViewKeyboard)
    func didDone(sender: PickerViewKeyboard, selectedData: String, selectedIndex: Int)
}
