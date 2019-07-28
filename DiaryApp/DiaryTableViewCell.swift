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
        dateLabel.text = diary.createdAt
    }
}
