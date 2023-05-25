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
    
    func basicActionAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            
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
    
    func minutesToHoursAndMinutes(_ minutes: Int?) -> String {
        if minutes != 0 {
            guard let minutes = minutes else { return "" }
            return "\(minutes / 60)h \(minutes % 60)m"
        }else{
            return "Runtime unknown"
        }
    }
    
    func convertToLongDate(_ releaseDate: String?) -> String {
        guard let date = releaseDate else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateObj = dateFormatter.date(from: date) else { return "" }
        
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.dateStyle = .long
        
        return "\(dateFormatter.string(from: dateObj))"
    }
}

extension Double {
    var stringValue:String {
        return "\(self)"
    }
}
