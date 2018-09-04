//
//  ReportViewController.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/3/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import SwiftCharts

class ReportViewController: EnterpriseViewController {

    let equities = ["MSFT", "TSLA", "NASQ"]
    let picker = UIPickerView()
    @IBOutlet weak var txtEquity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEquity.inputView = picker
        self.picker.delegate = self
        self.picker.dataSource = self
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTap)))
        // Do any additional setup after loading the view.
    }


    @objc fileprivate func onTap(){
        self.txtEquity.endEditing(true)
    }
}

extension ReportViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.equities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.equities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.equities[row])
        self.txtEquity.endEditing(true)
    }
    
}
