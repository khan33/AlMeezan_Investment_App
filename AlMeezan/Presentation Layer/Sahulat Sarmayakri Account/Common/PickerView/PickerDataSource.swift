//
//  PickerDataSource.swift
//  AlMeezan
//
//  Created by Atta khan on 28/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

struct GenericRow<T> {
    let type: T
    let title: String
    public init(type: T, title: String) {
        self.type = type
        self.title = title
    }
}

class GenericPickerDataSource<T>: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

    public var originalItems: [T]
    public var items: [GenericRow<T>]
    public var selected: (T) -> Void
    public var selectedRow: Int
    
    public init(withItems originalItems: [T], withRowTitle generateRowTitle: (T) -> String, row: Int, didSelect selected: @escaping (T) -> Void) {
        self.originalItems = originalItems
        self.selected = selected
        self.items = originalItems.map {
            GenericRow<T>(type: $0, title: generateRowTitle($0))
        }
        self.selectedRow = row
        self.selected(items[row].type)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected(items[row].type)
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: AppFontName.robotoRegular, size: pickerTitleFontSize)
        title.text =  items[row].title
        title.textAlignment = .center
        return title
    }
    
}




extension UITextField {

    func setupPickerField<T>(withDataSource dataSource: GenericPickerDataSource<T>) {
        let pickerView = UIPickerView()
        self.inputView = pickerView
        self.addDoneToolbar()
        pickerView.delegate = dataSource
        pickerView.dataSource = dataSource
        pickerView.selectRow(dataSource.selectedRow, inComponent: 0, animated: false)
    }

    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.tintColor = UIColor.blue

        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() {
        print("done button click")
        self.resignFirstResponder()
    }
}

struct Country1 {
    var id: Int
    var name: String
}
