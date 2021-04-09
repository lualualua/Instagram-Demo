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
    let padding: CGFloat = 1
    let itemsPerRow: CGFloat = 3
    
    var postImages = [UIImage(named: "1"), UIImage(named: "2"),
                      UIImage(named: "3"), UIImage(named: "4"),
                      UIImage(named: "5"), UIImage(named: "6"),
                      UIImage(named: "7"), UIImage(named: "8")]
    
    var arrSelectedIndex = [IndexPath]()
    var arrSelectedImages = [UIImage]()
    var comment: String = ""
    var imageView = [UIImage]()
    
    var delegate: passDataToTopViewDelegate?

    @IBOutlet weak private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextVCButton(_ sender: Any) {
        let addCommentVC = (storyboard?.instantiateViewController(withIdentifier: "addCommentVC")) as! AddCommentViewController
        addCommentVC.selectedImagesArr = arrSelectedImages
        addCommentVC.delegate = self
        navigationController?.pushViewController(addCommentVC, animated: true)

    }
}
extension AddPictureViewController: modalViewDelegate {
    func didUploadPost(comment: String, imageView: [UIImage]!) {
        delegate?.passDataToTop(comment: comment, imageView: imageView)
    }
    
    
}

extension AddPictureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postImages.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddPicCollectionViewCell
                
        //カメラのアイコン
        if indexPath.item == 0 {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
            cell.imageView.image = UIImage(systemName: "camera", withConfiguration: imageConfig)
            cell.imageView.contentMode = .center
            
        //「＋」マークのアイコン
        }else if indexPath.item == 1 {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
            cell.imageView.image = UIImage(systemName: "plus", withConfiguration: imageConfig)
            cell.imageView.contentMode = .center
        //それ以外のセルには写真を設定
        }else{
            cell.imageView.image = postImages[indexPath.row - 2]
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.sizeToFit()
        }
        return cell
    }
}

extension AddPictureViewController: UICollectionViewDelegateFlowLayout {
    //セルのサイズを設定
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
        let items = collectionView.indexPathsForSelectedItems
        let newItems = items?.filter {$0 != [0, 0] && $0 != [0, 1]}
        for item in newItems! {
            let cell = collectionView.cellForItem(at: item) as! AddPicCollectionViewCell

            guard let selectedImage = cell.imageView.image else { return }
            arrSelectedImages.append(selectedImage)
        }
    }
    
    //画像をCollectionViewへ追加
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let cameraPic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        postImages.append(cameraPic)
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}

//アルバムから写真を選択
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

                            let image = newImage as? UIImage
                            self?.postImages.append(image)
                            self?.collectionView.reloadData()
                    }
                }
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
