import UIKit

class CreateDiaryViewController: UIViewController {
   
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var implyWriteDiaryView: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    let saveData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        nameTextField.delegate = self
        contentTextView.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = saveData.string(forKey: "myName")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func postDiary() {
        if nameTextField.text!.isEmpty || titleTextField.text!.isEmpty || contentTextView.text.isEmpty {
            return
        }
        let diary = Diary(id: "", title: titleTextField.text!, content: contentTextView.text, posterName: nameTextField.text!, demandDeletionCount: 0, createdAt: "")
        DiaryManager.shared.create(diary: diary) {
            self.saveData.set(diary.posterName, forKey: "myName")
            let alert = UIAlertController(title: "DONE", message: "日記の投稿が完了しました。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.nameTextField.text = ""
                self.titleTextField.text = ""
                self.contentTextView.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func seeDiaries() {
        performSegue(withIdentifier: "toSeeDiary", sender: nil)
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
