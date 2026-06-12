import Foundation

extension Date {
    
    //---------------------------
    // Date Formater
    //---------------------------
    
    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f
    }()
        
    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    //---------------------------
    // Computed Property
    //---------------------------
    
    var formattedDate: String {
        Self.dateFormatter.string(from: self)
    }

    var dayName: String {
        Self.dayFormatter.string(from: self)
    }
        
    var formattedTime: String {
        Self.timeFormatter.string(from: self)
    }
    
    //---------------------------
    // Smart Formater
    //---------------------------
    
    var smartFormatted: String {
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return formattedTime
        }
        
        if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) {
            return dayName
        }
        
        return formattedDate
    }
}
