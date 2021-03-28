//
//  Model.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 16/03/21.
//

import Foundation
import UIKit

class Post: NSObject {
    
    var name: String
    var text: String
    var icon: UIImage!
    var postImage: UIImage!
    
    init(name: String, text: String, icon: UIImage!, postImage: UIImage! ) {
        self.name = name
        self.text = text
        self.icon = icon
        self.postImage = postImage
    }
//}
//var postImages = ["1", "2", "3", "4", "5", "6", "7", "8"]
//var texts = ["欲得づくの商人たちがしているすべての不正行為のうちで、種々の食べ物の誤魔化しほど非難すべきであり広く行き渡っているものはない。",
//    "考えが正しければ、その振る舞いも必ず正しくなる。行動が正しければ、生活も正しくなる。人生が正しければ、そこで必ず幸せになる。",
//    "窓の外にある景色を、ぼくは見ていた。",
//    "きみのおかげでリアルになれる そんな力を持っているのはきみだけ",
//    "寒い日だった",
//    "レコード入れを買おう  いつ踏んで　わってしまうかわらかない",
//    "その青さに一種の驚きに近い喜びをおぼえた",
//    "ヤケクソ"]

var posts: [Post] = []

func generatePost() -> [Post] {
    let name = "Osakana"
    
    return posts
    }

class func generateSamplePosts() -> [Post] {
    var posts: [Post] = []
    var postImages = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var texts = ["欲得づくの商人たちがしているすべての不正行為のうちで、種々の食べ物の誤魔化しほど非難すべきであり広く行き渡っているものはない。",
        "考えが正しければ、その振る舞いも必ず正しくなる。行動が正しければ、生活も正しくなる。人生が正しければ、そこで必ず幸せになる。",
        "窓の外にある景色を、ぼくは見ていた。",
        "きみのおかげでリアルになれる そんな力を持っているのはきみだけ",
        "寒い日だった",
        "レコード入れを買おう  いつ踏んで　わってしまうかわらかない",
        "その青さに一種の驚きに近い喜びをおぼえた",
        "ヤケクソ"]
    
    for i in 0..<8 {
        let name = "keita"
        let text = texts[i]
        let postImage = UIImage(named: postImages[i])
        let icon = UIImage(systemName: "ant.circle")
        let post = Post(name: name, text: text, icon: icon, postImage: postImage)
        posts.append(post)
    }
    return posts
  }
}
