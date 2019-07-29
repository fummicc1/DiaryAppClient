import Foundation
import UIKit

class SeeDiariesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var saveData = UserDefaults.standard
    var diaries: [Diary] {
        return DiaryManager.shared.diaries
    }
    var demandDeletionDiaryIDList: [String] {
        return DiaryManager.shared.demandDeletionDiaryIDList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DiaryManager.loadDiaries(demandDeletionDiaryIDList: demandDeletionDiaryIDList) { diaries in
            DiaryManager.shared.diaries = diaries
            self.tableView.reloadData()
        }
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    func deleteAction(diaryID: String, completion: @escaping () -> ()) {
        DiaryManager.deleteAction(currentDemandDeletionDiaryIDList: demandDeletionDiaryIDList, diaryID: diaryID) { error in
            if let error = error, error == .alreadyRequestDeletionAction {
                let alert = UIAlertController(title: "削除申請済み", message: "1つのアカウントで同じ投稿に削除要請を複数回出すことはできません。。。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if error == nil {
                self.saveData.set(self.demandDeletionDiaryIDList, forKey: "demandDeletionDiaryIDList")
                let alert = UIAlertController(title: "削除申請", message: "削除申請を送りました。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completion()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension SeeDiariesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell") as! DiaryTableViewCell
        cell.setup(diary: diaries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryID = diaries[indexPath.row].id
        let actionSheet = UIAlertController(title: "アクション", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "削除要請", style: .destructive, handler: { (_) in
            self.deleteAction(diaryID: diaryID, completion: {
                DiaryManager.shared.diaries.removeAll(where: {$0.id == diaryID})
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
        }))
        actionSheet.addAction(UIAlertAction(title: "戻る", style: .default, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
