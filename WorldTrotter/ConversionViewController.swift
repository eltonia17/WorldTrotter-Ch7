//
//  ViewController.swift
//  WorldTrotter
//
//  Created by Eltonia Leonard on 9/20/25.
//
import UIKit

final class ConversionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    //Format the numbers
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ConversionViewController loaded its view.")
        
        updateCelsiusLabel()
    }

    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text =
                        numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    //Bronze challenge add on
    // Disallow letters (allow only digits + one decimal separator)
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // allow backspace
        if string.isEmpty { return true }

        // block any alphabetic characters (covers the keyboard + pasting)
        if string.rangeOfCharacter(from: .letters) != nil { return false }

        // only digits and the locale decimal separator
        let dec = Locale.current.decimalSeparator ?? "."
        let allowed = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: dec))
        if string.rangeOfCharacter(from: allowed.inverted) != nil { return false }

        let current = textField.text ?? ""
        guard let r = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: r, with: string)

        // at most one decimal separator in the whole string
        if updated.components(separatedBy: dec).count - 1 > 1 { return false }

        return true
    }

    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        // Set Celsius text field
        if let text = textField.text, let value = Double(text) {
                fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
            } else {
                fahrenheitValue = nil
            }
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    
}
