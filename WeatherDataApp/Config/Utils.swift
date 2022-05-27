//
//  ReUsables.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/20/22.
//

import Foundation

class Utils {
        
    // function to roundoff number to a given decimal place
    static func roundOff(value: Double, decmialPoint: Int) -> Double {
        return Double(round(pow(10.0, Double(decmialPoint)) * value) / 100.0 )
    }
    
    // filter to get only specidied days weather data
    static func isDaysOutOfRange(days: Int, date : Date) -> Bool {
        
        // get date of 4 days from now
        var dateComponent = DateComponents()
        dateComponent.day = days
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: Date())
       
        // eliminate time and get only the date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let firstDate = formatter.string(from: futureDate ?? Date())
        let secondDate = formatter.string(from: date)

        
        // compare the 2 dates as strings - this helps us to ignore the time
        if firstDate.compare(secondDate) == .orderedAscending {
            return false
        }
        return true
    }
    
    // function to allow only letters
    static func containsSpecialCharactersOrNumbers(text: String) -> Bool {
        // set the allowed characters - hard coded the character set as text is also allowed to contain whitespaces
        let characterSet: CharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        // check for special characters or numbers
        if (text.rangeOfCharacter(from: characterSet.inverted) != nil) {
            return false
        }
        return true
    }
    
    // func to convert string date to iso format
    static func getISODate(date: String) -> Date {
        
        // format the string date to iso format string
        let formattedDate = date.replacingOccurrences(of: " ", with: "T") + Timezones.LK.rawValue
        
        // format the string to iso format Date
        let dateFormatter = ISO8601DateFormatter()
        let isoDate = dateFormatter.date(from: formattedDate)!
        
        return isoDate
    }
    

}
