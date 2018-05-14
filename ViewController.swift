//
//  ViewController.swift
//  Diabeathis
//
//  Created by Ti. Jr on 7/1/17.
//  Copyright © 2017 Twang. All rights reserved.
//

import UIKit
import UserNotifications


class ViewController: UIViewController, UNUserNotificationCenterDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var bloodSugarField: UITextField!
    @IBOutlet weak var targetBloodSugarField: UITextField!
    @IBOutlet weak var carbsPerInsulinUField: UITextField!
    @IBOutlet weak var carbsEatenField: UITextField!
    @IBOutlet weak var correctionFactorField: UITextField!
    @IBOutlet weak var percentOfDoseField: UITextField!
    
    // Make sure to return X.xx units
    @IBOutlet weak var insulinDose: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Check if user would like to enable notifications.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hide the keyboard when User touches outside the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide the keyboard when User hits the return key.
   @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bloodSugarField.resignFirstResponder()
        targetBloodSugarField.resignFirstResponder()
        carbsEatenField.resignFirstResponder()
        carbsPerInsulinUField.resignFirstResponder()
        correctionFactorField.resignFirstResponder()
        percentOfDoseField.resignFirstResponder()
        
        return (true)
    }
    
    // Enable Notifications.
    @IBAction func remindUserNotification(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = "You can Diabeathis."
        content.body = "This is a reminder to take insulin for your meals. Use our app to calculate your dose in less than a second."
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (120 * 60), repeats: true)
        
        let request = UNNotificationRequest(identifier: "stayOnTrack", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    func reminderAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        reminderAlert(title: "PLEASE NOTE", message: "You will be notified every two hours to take insulin. #YouCanDiabeathis")
    }
    
    // Enable a button that calculates insulin dose with above functions.
    @IBAction func insulinCalculator(_ sender: UIButton) {
        
        self.bloodSugarField.delegate = self
        self.targetBloodSugarField.delegate = self
        self.carbsPerInsulinUField.delegate = self
        self.carbsEatenField.delegate = self
        self.correctionFactorField.delegate = self
        self.percentOfDoseField.delegate = self
        
        let firstValue: Double? = Double(bloodSugarField.text!)
        let secondValue: Double? = Double(targetBloodSugarField.text!)
        let thirdValue: Double? = Double(carbsPerInsulinUField.text!)
        let fourthValue: Double? = Double(carbsEatenField.text!)
        let fifthValue: Double? = Double(correctionFactorField.text!)
        let sixthValue: Double? = Double(percentOfDoseField.text!)
        
        if firstValue != nil && secondValue != nil && thirdValue != nil && fourthValue != nil && fifthValue != nil && firstValue! > 0.00 && secondValue! > 0 && thirdValue! > 0 && fourthValue! >= 0 && fifthValue! > 0  {
            
            
            if firstValue! > secondValue! {
                
                func highAlert(title: String, message: String) {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                highAlert(title: "PLEASE NOTE", message: "If your blood glucose is higher than normal, make sure to drink plenty of water. #YouCanDiabeathis")
                let BGCorrection = (firstValue! - secondValue!) / fifthValue!
                let CarbCountInsulin = fourthValue! / thirdValue!
                let totalInsulin = BGCorrection + CarbCountInsulin
                let percentageInsulin = totalInsulin * (sixthValue! / 100)
                let insulinNeeded: Float = Float(percentageInsulin)
                
                insulinDose.text = "Your Dosage: \(insulinNeeded) units"
                
            } else if firstValue! <= secondValue! {
                
                func lowAlert(title: String, message: String) {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                lowAlert(title: "PLEASE NOTE", message: "If your blood glucose is low, please adjust your dosage accordingly. #YouCanDiabeathis")
                
                
                let CarbCountInsulin = fourthValue! / thirdValue!
                let percentageInsulin = CarbCountInsulin * (sixthValue! / 100)
                let insulinNeeded: Float = Float(percentageInsulin)
                
                insulinDose.text = "Your Dose: \(insulinNeeded) units"
            }
        } else {
            func provideAlert(title: String, message: String) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            provideAlert(title: "INVALID INPUT", message: "Please enter a valid positive numerical value for each field. We must provide you with the most precise dose. #YouCanDiabeathis")
        }
    }
}
















