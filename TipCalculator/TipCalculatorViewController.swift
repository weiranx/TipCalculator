//
//  ViewController.swift
//  TipCalculator
//
//  Created by Weiran Xiong on 12/5/18.
//  Copyright © 2018 Weiran Xiong. All rights reserved.
//

import UIKit

class TipCalculatorViewController: UIViewController {
    
    // constants
    let customTipIndex = 2
    
    // IBOutlets
    @IBOutlet weak var inputAmountTextField: UITextField!
    @IBOutlet weak var tipSegmentControl: UISegmentedControl!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var divideSlider: UISlider!
    @IBOutlet weak var divideNumLabel: UILabel!
    @IBOutlet weak var amountForEachLabel: UILabel!
    @IBOutlet weak var invalidAlertLabel: UILabel!
    
    // Data models
    var amount: Double = 0
    var tipPercent: Double = 0
    var tipAmount: Double = 0
    var totalAmount: Double = 0
    var numOfPeople = 1
    var amountForEach: Double = 0
    
    var tipOptions = [TipOption]()
    
    var currencySymbol = "$"
    
    var shouldRemember = true
    
    @IBAction func inputAmountValueChanged(_ sender: UITextField) {
        updateUI()
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        updateUI()
    }
    @IBAction func divideSliderChanged(_ sender: Any) {
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipOptions.append(TipOption(15))
        tipOptions.append(TipOption(18))
        tipOptions.append(TipOption(20))
        
        setupUI()
        
        resetShouldRemember()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputAmountTextField.becomeFirstResponder()
        if (shouldRemember) {
            loadData()
        }
        
        updateUI()
    }

    // Helpers
    private func setupUI() {
        invalidAlertLabel.alpha = 0
        setupTipSegmentControl()
        setupInputTextField()
        setupSlider()
    }
    private func setupTipSegmentControl() {
        for (i, tipOption) in tipOptions.enumerated() {
            tipSegmentControl.setTitle(tipOption.displayText, forSegmentAt: i)
        }
    }
    private func setupInputTextField() {
        inputAmountTextField.placeholder = "$"
        inputAmountTextField.text = "0"
    }
    private func setupSlider() {
        divideSlider.minimumValue = 1
        divideSlider.maximumValue = 4
    }
    
    
    
    private func updateTipAmount() {
        setupTipSegmentControl()
        tipPercent = tipOptions[tipSegmentControl.selectedSegmentIndex].tipPercent
    }
    private func updateAmount() {
        guard let newAmount = Double(inputAmountTextField.text!) else {
            UIView.animate(withDuration: 0.2) {
                self.invalidAlertLabel.alpha = 1
                self.inputAmountTextField.textColor = UIColor.red
            }
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.invalidAlertLabel.alpha = 0
            self.inputAmountTextField.textColor = UIColor.black
        }
        amount = newAmount
    }
    private func updateSlider() {
        numOfPeople = Int(divideSlider.value)
        divideNumLabel.text = "\(numOfPeople)"
        amountForEach = totalAmount / Double(numOfPeople)
    }
    
    func updateUI() {
        
        updateAmount()
        updateTipAmount()
        tipAmount = amount * tipPercent
        totalAmount = amount + tipAmount
        updateSlider()
        
        let amountString = String(format: "%.2f", amount)
        let tipAmountString = String(format: "%.2f", tipAmount)
        let totalAmountString = String(format: "%.2f", totalAmount)
        let amountForEachString = String(format: "%.2f", amountForEach)
        
        tipAmountLabel.fadeTransition(0.2)
        totalAmountLabel.fadeTransition(0.2)
        amountForEachLabel.fadeTransition(0.2)
        self.tipAmountLabel.text = "Tips: \(self.currencySymbol)\(tipAmountString)"
        self.totalAmountLabel.text = "Total: \(self.currencySymbol)\(amountString) + \(self.currencySymbol)\(tipAmountString) = \(self.currencySymbol)\(totalAmountString)"
        self.amountForEachLabel.text = "Amount for each: \(self.currencySymbol)\(amountForEachString)"

        saveData()
    }
    
    private func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(amount, forKey: "amount")
        defaults.set(divideSlider.value, forKey: "sliderValue")
        defaults.set(tipSegmentControl.selectedSegmentIndex, forKey: "segmentIndex")
        defaults.set(tipOptions[2].tipPercentNum, forKey: "customTipNum")
        defaults.synchronize()
    }
    private func loadData() {
        let defaults = UserDefaults.standard
        amount = defaults.double(forKey: "amount")
        inputAmountTextField.text = "\(amount)"
        divideSlider.setValue(defaults.float(forKey: "sliderValue"), animated: false)
        tipSegmentControl.selectedSegmentIndex = defaults.integer(forKey: "segmentIndex")
        
        var customTipNum = defaults.integer(forKey: "customTipNum")
        if (customTipNum == 0) {
            customTipNum = 20
        }
        
        tipOptions[2] = TipOption(customTipNum)
    }
    
    func resetShouldRemember() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "shouldRemember") == false {
            shouldRemember = false
        } else {
            shouldRemember = true
        }
    }

    
}


extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
