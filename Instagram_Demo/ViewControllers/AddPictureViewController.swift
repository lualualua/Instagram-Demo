//
//  AddPictureViewController.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 14/03/21.
//

import UIKit
import PhotosUI

protocol passDataToTopViewDelegate {
    func passDataToTop(comment: String, imageView: [UIImage]!)
}

class AddPictureViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak private var collectionView: UICollectionView!
    private let padding: CGFloat = 1
    private let itemsPerRow: CGFloat = 3
    private var postImages = [UIImage]()
    private var arrSelectedImages: [UIImage] = []
    private var comment: String = ""
    private var imageView = [UIImage]()

    var delegate: passDataToTopViewDelegate?
    
    //カメラ・「＋」マークのアイコン、写真のセルを識別
    enum Item: Int {
        case Camera
        case Album
        case Others
        
        init(rawValue: Int) {
            if rawValue == 0 {
                self = .Camera
            } else if rawValue == 1 {
                self = .Album
            } else {
                self = .Others
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupcollectionView()
    }
    
    //CollectionViewの設定
    func setupcollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
    }
    
    //キャンセルボタンを押した時
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //「次へ」ボタンを押した時
    @IBAction func nextVCButton(_ sender: Any) {
        let addCommentVC = (storyboard?.instantiateViewController(withIdentifier: "addCommentVC")) as! AddCommentViewController
        if arrSelectedImages.isEmpty {return}
            addCommentVC.selectedImagesArr = arrSelectedImages
            addCommentVC.delegate = self
            navigationController?.pushViewController(addCommentVC, animated: true)
    }
}

//データをTopViewControllerへ渡す
extension AddPictureViewController: modalViewDelegate {
    func didUploadPost(comment: String, imageView: [UIImage]!) {
        delegate?.passDataToTop(comment: comment, imageView: imageView)
    }
}

//CollectionView（写真）のセル数、セルの設置
extension AddPictureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postImages.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddPicCollectionViewCell
        let item = Item(rawValue: indexPath.item)
        switch item {
        case .Camera: //カメラのアイコン
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "camera", withConfiguration: imageConfig)
            cell.setImage(image: image!)
        case .Album: //「＋」マークのアイコン
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
            cell.setImage(image: image!)
        case .Others:
            let image = postImages[indexPath.row - 2]
            cell.setImage(image: image)
            cell.imageView.contentMode = .scaleAspectFill
        }
        return cell
    }
}

//セルのサイズを設定
extension AddPictureViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = padding * (itemsPerRow - 1)
        let availableWidth = view.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     return padding
    }
}


extension AddPictureViewController: UICollectionViewDelegate, UIImagePickerControllerDelegate {
    //各セルを選択した時の挙動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell : UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        let cell = collectionView.cellForItem(at: indexPath) as! AddPicCollectionViewCell

        //「カメラ」ボタンを押したらカメラを起動
        if indexPath.item == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                present(imagePickerController, animated: true, completion: nil)
            }
            //「選択状態」の枠線は付けない
            selectedCell.layer.borderWidth = 0
        }
        
        //「＋」マークを押したらアルバムから写真を選べる。選択状態」の枠線は付けない
            else if indexPath.item == 1 {
                    selectPhoto()
                    selectedCell.layer.borderWidth = 0
                }
            
        //カメラ・＋マーク以外のセルを選択した時、セルの写真データを保存
            else {
                let selectedImage = cell.imageView.image
            arrSelectedImages.append(selectedImage!)
            }
        }

    //セルの選択を解除した時
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AddPicCollectionViewCell
        let selectedImage = cell.imageView.image
        arrSelectedImages = arrSelectedImages.filter {$0 != selectedImage}
    }
    
    //画像をCollectionViewへ追加する
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let cameraPic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        postImages.append(cameraPic)
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}


//アルバムを開いて写真を選択する
extension AddPictureViewController: PHPickerViewControllerDelegate {

    func selectPhoto() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for image in results {
            if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                        DispatchQueue.main.async {

                            guard let image = newImage as? UIImage else { return }
                            self?.postImages.append(image)
                            self?.collectionView.reloadData()
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
