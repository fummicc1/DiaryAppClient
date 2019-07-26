import UIKit

class DiaryTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var posterLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    func setup(diary: Diary) {
        titleLabel.text = diary.title
        contentLabel.text = diary.content
        posterLabel.text = "投稿者: \(diary.posterName)"
        dateLabel.text = diary.createdAt.convertToString()
    }
}

extension Date {
    func convertToString() -> String {
        if Int(Date().timeIntervalSince(self)) >= 3600 * 24 * 3 {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter.string(from: self)
        } else {
            if Int(Date().timeIntervalSince(self)) / 3600 / 24 >= 1 {
                return "\(Int(Date().timeIntervalSince(self)) / 3600 / 24)d"
            } else {
                if Date().timeIntervalSince(self) / 3600 >= 1 {
                    return "\(Int(Date().timeIntervalSince(self)) / 3600)h"
                } else if Date().timeIntervalSince(self) / 60 >= 1 {
                    return "\(Int(Date().timeIntervalSince(self)) / 60)m"
                } else {
                    return "\(Int(Date().timeIntervalSince(self)))s"
                }
            }
        }
    }
}
