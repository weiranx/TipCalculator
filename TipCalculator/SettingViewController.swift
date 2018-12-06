//
//  SettingViewController.swift
//  TipCalculator
//
//  Created by Weiran Xiong on 12/5/18.
//  Copyright © 2018 Weiran Xiong. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var customTipAmountTextField: UITextField!
    let defaults = UserDefaults.standard
    
    @IBAction func doneButton(_ sender: Any) {

  
        let tipController = (navigationController?.presentingViewController as! UINavigationController).viewControllers[0]  as! TipCalculatorViewController

        tipController.tipOptions[2] = TipOption(Int(customTipAmountTextField?.text ?? "20") ?? 20)
        tipController.updateUI()

        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rememberButton(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: "shouldRemember")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        rememberSwitch.setOn(defaults.bool(forKey: "shouldRemember"), animated: false)
        
        customTipAmountTextField.text = "\(defaults.integer(forKey: "customTipNum"))"
    }
    

}


struct TipOption {
    var tipPercentNum: Int = 0 // tipPercentNum%
    var tipPercent: Double {
        get {
            return Double(tipPercentNum) / 100
        }
    }
    var displayText: String {
        get {
            return "\(tipPercentNum)%"
        }
    }
    
    init(_ num: Int) {
        tipPercentNum = num
    }
}
