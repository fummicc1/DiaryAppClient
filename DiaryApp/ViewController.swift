import UIKit

class ViewController: UIViewController {
   
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        nameTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDiaries()
    }
    
    func loadDiaries() {
        let url = URL(string: "http:localhost:8080/diary/load")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let diaryList = try? JSONDecoder().decode([Diary].self, from: data) else {
                return
            }
            print(diaryList)
        }.resume()
    }
    
    @IBAction func postDiary() {
        if nameTextField.text?.isEmpty == false && titleTextField.text?.isEmpty == false && contentTextView.text.isEmpty == false {
            let diary = Diary(title: titleTextField.text!, content: contentTextView.text!, posterName: nameTextField.text!, createdAt: Date())
            let url = URL(string: "http:localhost:8080/diary/create")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("/application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(diary)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
            }.resume()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
