import Foundation

class DiaryManager {
    static let shared = DiaryManager()
    
    var diaries: [Diary] = []
    var demandDeletionDiaryIDList: [String] {
        return UserDefaults.standard.value(forKey: "demandDeletionDiaryIDList") as? [String] ?? []
    }
    
    static func loadDiaries(demandDeletionDiaryIDList: [String], completion: @escaping ([Diary]) -> ()) {
        let url = URL(string: Private.baseUrlString + "diary/load")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, var diaries = try? JSONDecoder().decode([Diary].self, from: data) else {
                return
            }
            for diary in diaries {
                if
                    diary.demandDeletionCount > 10 ||
                    demandDeletionDiaryIDList.contains(diary.id) {
                    diaries.removeAll(where: {$0.id == diary.id})
                }
            }
            DispatchQueue.main.async {
                completion(diaries)
            }
            }.resume()
    }
    
    static func create(diary: Diary, completion: @escaping () -> ()) {
        let url = URL(string: Private.baseUrlString + "diary/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("/application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(diary)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion()
            }
            }.resume()
    }
    
    static func deleteAction(currentDemandDeletionDiaryIDList: [String], diaryID: String, completion: @escaping (DatabaseError?) -> ()) {
        if currentDemandDeletionDiaryIDList.contains(diaryID) {
            completion(.alreadyRequestDeletionAction)
            return
        }
        guard let url = URL(string: Private.baseUrlString + "diary/delete/\(diaryID)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            UserDefaults.standard.set(currentDemandDeletionDiaryIDList + [diaryID], forKey: "demandDeletionDiaryIDList")
            DispatchQueue.main.async {
                completion(nil)
            }
            }.resume()
    }
    
}

enum DatabaseError: Error {
    case alreadyRequestDeletionAction
}
