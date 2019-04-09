import Foundation
import CoreMedia

public struct TimecodeFormatter {

    private static var longTimeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.collapsesLargestUnit = false
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    private static var shortTimeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.collapsesLargestUnit = true
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    public let time: CMTime
    public init(time: CMTime) {
        self.time = time
    }

    public var longFormat: String {
        return type(of: self).longTimeFormatter.string(from: time.seconds) ?? "0:00:00"
    }

    public var shortFormat: String {
        return type(of: self).shortTimeFormatter.string(from: time.seconds) ?? ""
    }

}
