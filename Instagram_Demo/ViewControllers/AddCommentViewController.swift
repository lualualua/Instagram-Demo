//
//  AddCommentViewController.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 14/03/21.
//

import UIKit

protocol modalViewDelegate {
    func didUploadPost(comment: String, imageView: [UIImage?])
}

class AddCommentViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    var placeholderLabel : UILabel!
    var selectedImagesArr = [UIImage]()
    let cellScale: CGFloat = 0.9
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    var insetX: CGFloat!
    var insetY: CGFloat!
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    var collectionViewSize: CGFloat!
    var toolbarHeight: CGFloat!
    
    var delegate: modalViewDelegate?
    var topbarHeight: CGFloat {
         return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
             (self.navigationController?.navigationBar.frame.height ?? 0.0)
     }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        textView.delegate = self
        
        //TextViewにプレースホルダーを設置
        placeholderLabel = UILabel()
        placeholderLabel.text = "コメントを追加"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        toolBar.sizeToFit()
        toolbarHeight = toolBar.frame.height
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonTapped))
        
        toolBar.items = [spacer, doneButton]
        textView.inputAccessoryView = toolBar
        
        updateCount()
    }
    
    //投稿ボタンを押したらモーダルを閉じる
    @IBAction func uploadButton(_ sender: Any) {
        guard let comment = textView.text else {return}
//        self.dismiss(animated: true, completion: nil)
        delegate?.didUploadPost(comment: comment, imageView: selectedImagesArr)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height + toolbarHeight + topbarHeight
            } else { return }
        }
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }

}

extension AddCommentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImagesArr.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        cell.imageView.image = selectedImagesArr[indexPath.item]
        cell.imageView.layer.cornerRadius = 10.0
        cell.imageView.contentMode = .scaleAspectFill
        
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let collectionViewSize = collectionView.bounds.size
            cellWidth = floor(UIScreen.main.bounds.width * cellScale)
            cellHeight = collectionViewSize.height
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        insetX = (collectionView.bounds.width - cellWidth) / 4.0
        insetY = (collectionView.bounds.height - cellHeight) / 2.0
        
        return UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return insetX
    }
}

extension AddCommentViewController: UITextViewDelegate {
    
    //TextViewの文字数に制限を設ける
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= 100
    }
    //文字数カウントラベルの表示
    func updateCount() {
        let count = textView.text.count
        countLabel.textColor = UIColor.lightGray
        countLabel.text = "\((0) + count) / 100"
    }
    
    //文字が入力されたらカウント、ラベル表示、プレースホルダーの非表示
    func textViewDidChange(_ textView: UITextView) {
        updateCount()
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
