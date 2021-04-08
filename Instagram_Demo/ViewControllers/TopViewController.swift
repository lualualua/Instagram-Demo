//
//  TopTableViewController.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 11/03/21.
//

import UIKit
import PhotosUI

class TopTableViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    var posts = [Post]()
    
    //collectionViewCell間のpadding
    let padding: CGFloat = 0.5
    let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        posts = Post.generateSamplePosts()
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailTableViewCellViewController
    }
    
    //投稿を追加ボタンをクリック
    @IBAction func addButton(_ sender: Any) {
        let addPictureVC = storyboard?.instantiateViewController(withIdentifier: "addPicVC") as! UINavigationController
        addPictureVC.modalPresentationStyle = .fullScreen
        self.present(addPictureVC, animated: true, completion: nil)
//
//        let vc = AddPictureViewController()
//        let vc2 = AddCommentViewController()
//        vc2.delegate = self
//        let navigationController = UINavigationController(rootViewController: vc)
//        present(navigationController, animated: true, completion: nil)
    }

}

//投稿追加のモーダルを閉じる
extension TopTableViewController: modalViewDelegate {
    func didUploadPost(comment: String, imageView: [UIImage?]) {
//        let addCommentVC = storyboard?.instantiateViewController(withIdentifier: "addCommentVC") as! AddCommentViewController
//        addCommentVC.delegate = self
//        addCommentVC.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TopTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! TopCollectionViewCell
        cell.setImage(post: posts[indexPath.row])
        return cell
    }
    
    
}

extension TopTableViewController: UICollectionViewDelegateFlowLayout {
    //セルの大きさを計算。画面サイズに合わせて大小変化する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = padding * (itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    //写真をクリックしたら、それぞれの投稿内容に移動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = (storyboard?.instantiateViewController(identifier: "detailTableviewVC"))! as DetailTableViewCellViewController
        detailVC.post = posts[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}



    

