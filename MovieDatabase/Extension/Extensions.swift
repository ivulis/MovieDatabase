//
//  Extension.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 23/05/2023.
//

import UIKit

extension UIViewController {
    
    func basicAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
        }
    }
    
    func activityIndicator(activityIndicatorView: UIActivityIndicatorView, animated: Bool) {
        DispatchQueue.main.async {
            if animated {
                activityIndicatorView.isHidden = false
                activityIndicatorView.startAnimating()
            }else{
                activityIndicatorView.isHidden = true
                activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func changeToAdd(_ button: UIButton) {
        button.layer.backgroundColor = UIColor.yellow.cgColor
        button.layer.borderWidth = 0
        button.setTitle("+ Add to Watchlist", for: .normal)
        button.setTitleColor(.black, for: .normal)
    }
    
    func changeToAdded(_ button: UIButton) {
        button.layer.backgroundColor = UIColor.systemGray6.cgColor
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.yellow.cgColor
        button.setTitle("✓ Added to Watchlist", for: .normal)
        button.setTitleColor(.white, for: .normal)
    }
}

extension Optional where Wrapped == Double  {

    var stringValue: String {
        guard let value = self else { return "No Value Provided" }
        return String(format: "%.1f", value)
    }
}

extension Optional where Wrapped == String {
    
    var longDateString: String {
        guard let date = self else { return "No Value Provided" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateObj = dateFormatter.date(from: date) else { return "" }
        
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.dateStyle = .long
        
        return "\(dateFormatter.string(from: dateObj))"
    }
    
    var stringValue: String {
        guard let value = self else { return "No Value Provided" }
        return value
    }
}

extension Optional where Wrapped == Int {
    
    var hoursAndMinutes: String {
        guard let minutes = self else { return "No Value Provided" }
        
        if minutes != 0 {
            return "\(minutes / 60)h \(minutes % 60)m"
        }else{
            return "Runtime unknown"
        }
    }
    
    var stringValue: String {
        guard let value = self else { return "No Value Provided" }
        return "\(value)"
    }
}
