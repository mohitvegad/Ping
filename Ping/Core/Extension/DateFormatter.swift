import Foundation

extension Date {
    
    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd MMM yyyy"
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
    
    var formattedDate: String {
        Self.dateFormatter.string(from: self)
    }

    var dayName: String {
        Self.dayFormatter.string(from: self)
    }
        
    var formattedTime: String {
        Self.timeFormatter.string(from: self)
    }
}
