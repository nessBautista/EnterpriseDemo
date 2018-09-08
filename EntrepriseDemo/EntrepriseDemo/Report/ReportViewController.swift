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

    /*
     Microsoft: MSFT
     Apple: AAPL
     General Electric: GE
     Facebook: FB
     Google Alphabet: GOOG
     */
    let equities = ["MSFT", "AAPL", "GE", "FB", "GOOGL"]
    let picker = UIPickerView()
    var vcReportGraph : RangedAxisExample?
    
    @IBOutlet weak var lblMetadata: UILabel!
    
    
    @IBOutlet weak var txtEquity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEquity.inputView = picker
        self.picker.delegate = self
        self.picker.dataSource = self
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTap)))
        // Do any additional setup after loading the view.
    }

    fileprivate func loadReport(_ equity:String){
        LibraryAPI.shared.bo.getTimeSeriesFor(equity: equity, onSuccess: { (timeSeries) in
            
            self.vcReportGraph?.loadGraph(timeSeries)
            
        }) { (error) in
            print(error)
        }
    }

    @objc fileprivate func onTap(){
        self.txtEquity.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "RangedAxisExample" {
            self.vcReportGraph = segue.destination as? RangedAxisExample
        }
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
        let company = self.equities[row]
        print(self.equities[row])
        self.loadReport(company)
        self.txtEquity.endEditing(true)
    }
    
}
