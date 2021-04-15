//
//  AddCommentViewController.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 14/03/21.
//

import UIKit

protocol modalViewDelegate {
    func didUploadPost(comment: String, imageView: [UIImage]!)
}

class AddCommentViewController: UIViewController {

    @IBOutlet weak private var imageCollectionView: UICollectionView!
    @IBOutlet weak private var textView: UITextView!
    @IBOutlet weak private var countLabel: UILabel!
    private var placeholderLabel : UILabel!
    var selectedImagesArr = [UIImage]()
    private let cellScale: CGFloat = 0.9
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var insetX: CGFloat!
    private var collectionViewSize: CGFloat!
    private var toolbarHeight: CGFloat!
    
    var delegate: modalViewDelegate?
    
    //画面上部のstatusBarとNavigationBarの高さ
    var topbarHeight: CGFloat {
         return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
             (self.navigationController?.navigationBar.frame.height ?? 0.0)
     }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        textView.delegate = self
        
        setPlaceholder()
        setToolBar()
        updateCount()
    }
    
    //TextViewにプレースホルダーを設置
    func setPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "コメントを追加"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //キーボード上部に「Done」ボタンを設置
    func setToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        toolBar.sizeToFit()
        toolbarHeight = toolBar.frame.height
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonTapped))
        
        toolBar.items = [spacer, doneButton]
        textView.inputAccessoryView = toolBar
    }
    
    //投稿ボタンを押したらモーダルを閉じる
    @IBAction func uploadButton(_ sender: Any) {
        guard let comment = textView.text else {return}
        self.dismiss(animated: true, completion: nil)
        delegate?.didUploadPost(comment: comment, imageView: selectedImagesArr)
    }

    //キーボードが表示されたら画面を上部へ持ち上げる
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height + toolbarHeight + topbarHeight
            } else { return }
        }
    }
    
    //キーボードが閉じたら画面を元に戻す（下へ下げる）
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    //キーボード外をクリックしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //キーボードのDoneボタンを押すとき
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
}

//CollectionView（写真）のセル数、セルの設置
extension AddCommentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImagesArr.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCommentCollectionViewCell", for: indexPath) as! AddCommentCollectionViewCell
        let image = selectedImagesArr[indexPath.item]
        cell.setupCell(image: image)
        return cell
        }
}

//CollectionView（写真）のセルサイズ
extension AddCommentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewSize = collectionView.bounds.size
            cellWidth = floor(UIScreen.main.bounds.width * cellScale)
            cellHeight = collectionViewSize.height
            return CGSize(width: cellWidth, height: cellHeight)
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if selectedImagesArr.count == 1 {
            insetX = (collectionView.bounds.width - cellWidth) / 2.0
            return UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        }
        insetX = (collectionView.bounds.width - cellWidth) / 4.0
        return UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insetX
    }
}

//コメントを入れるTextViewの設定
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
