import UIKit

class CreateDiaryViewController: UIViewController {
   
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var implyWriteDiaryView: UILabel!
    
    var diaries: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        nameTextField.delegate = self
        contentTextView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDiaries()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSeeDiary" {
            let destination = segue.destination as! SeeDiariesViewController
            destination.diaries = sender as! [Diary]
        }
    }
    
    func loadDiaries() {
        let url = URL(string: "http:localhost:8080/diary/load")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let diaries = try? JSONDecoder().decode([Diary].self, from: data) else {
                return
            }
            self.diaries = diaries
        }.resume()
    }
    
    @IBAction func postDiary() {
        if nameTextField.text!.isEmpty || titleTextField.text!.isEmpty || contentTextView.text.isEmpty {
        }
        let diary = Diary(title: titleTextField.text!, content: contentTextView.text!, posterName: nameTextField.text!, createdAt: Date())
        let url = URL(string: "http:localhost:8080/diary/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("/application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(diary)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                let alert: UIAlertController
                if error == nil {
                    alert = UIAlertController(title: "DONE", message: "日記の投稿が完了しました。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.nameTextField.text = ""
                        self.titleTextField.text = ""
                        self.contentTextView.text = ""
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    alert = UIAlertController(title: "エラー", message: "日記の投稿に失敗しました。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "リトライ", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }.resume()
    }
    
    @IBAction func seeDiaries() {
        performSegue(withIdentifier: "toSeeDiary", sender: diaries)
    }
}

extension CreateDiaryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        implyWriteDiaryView.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        implyWriteDiaryView.isHidden = true
    }
}
