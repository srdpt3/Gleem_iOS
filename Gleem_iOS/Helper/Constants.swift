//
//  Constants.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage



let screen = UIScreen.main.bounds
let APP_LOGO = "gleem_resized"


let COLOR_LIGHT_GRAY = Color(red: 0, green: 0, blue: 0, opacity: 0.15)
let APP_THEME_COLOR = Color("Color2")

let INITIAL_POINT = 500
let POINT_USE = 10

// Tabbar
public let index1 = "카드"
public let index2 = "내 이미지"
public let index3 = "호감"
public let index4 = "채팅"
public let TABBAR_FONT_SIZE = 13


public var BELL = "bell"
public var FONT = "JSDongkang-Regular"
public var FONT_BOLD = "JSDongkang-Bold"
public let BUTTON_TITLE_FONT_SIZE = 18

//public var FONT = "CookieRun Regular"

public let VOTE_NUMBER = "numVote"
public let CHART_Y_AXIS = 100




// Sign in and Sign up pages
let TEXT_NEED_AN_ACCOUNT = "Don't have an account?"
let TEXT_SIGN_UP = "Sign up"
let TEXT_SIGN_IN = "Sign in"
let TEXT_EMAIL = "이메일"
let TEXT_USERNAME = "ID"
let TEXT_PASSWORD = "비밀번호"
let TEXT_PASSWORD_REENTER = "비밀번호 다시입력"

let TEXT_SIGNIN_SUBHEADLINE = "The essiest way to share photos with family and friends"
let TEXT_SIGNUP_NOTE = "An account will allow you to save and access photo information across devices. You can delete your account at any time and your information will not be shared."
let TEXT_SIGNUP_PASSWORD_REQUIRED = "At least 8 characters required"
let TERM_AGREEMENT = "I Read And Agree The Terms And Conditions"
let TERM_AGREEMENT2 = "약관에 동의합니다"



let IMAGE_LOGO = "logo"
let IMAGE_USER_PLACEHOLDER = "user-placeholder"
let IMAGE_PHOTO = "plus.circle"


// FOOTER VIEW
public let BUTTONNAME  = "첫인상 투표하기"
public let BUTTONNAME_AFTER_VOTE  = "카드 다시보기"


//FLAG
public let BLOCKUSER = "신고해주셔서 감사합니다"
public let BLOCK_BUTTON = " 신고하기"
public let CACEL_BLOCK_BUTTON = "취소"
public let FLAGPICTURE_TITLE = "사진을 신고합니다"
public var data = ["혐오성 음란한사진","개인정보 노출","욕설이 담긴 사진", "선정적인 사진"]

//Vote

//Expanded View
public let VOTE_SUBMIT_BUTTON = "첫인상반영하고 결과보기"
public let RATING_TEXT = "이미지 호감도"
public let USER_RESULT = " 님의 실시간 이미지투표 결과"

//Chart
public let SERIES_TITLE = "매력지수(%)"


//Menu
public let PROFILE_COMPLETE = "70% 완료"
public let ACCOUNT = "계정"
public let PROFILE = "프로필"
public let BILLING = "포인트 충전"
public let LOGIN = "로그인"
public let LOGOUT = "로그아웃"


// Upload voting picture
public let PHOTOUPLOAD = "평가받고 싶은 사진 올리기"

//CHAT
public let SEND_LIKE_MESSAGE = "안녕하세요" + User.currentUser()!.username + "님께서 관심을 표현하였습니다."
public let MESSAGEVIEW_TITLE = "채팅"



//Notification
public let ACTIVITY = "알림"
public let LIKED_MESSAGE = "님이 끌림을 주셧습니다"
public let MATCHED_MESSAGE = "님과 서로 연결이 되었습니다. \n채팅창에서 인사해보세요 ^^"

//Chat View
public let TYPE_MESSAGE = "메세지를 입력해주세요"
public let LEAVE_ROOM =  "채팅방 나가기"
public let END_CHAT =  "이랑 대화를 종료합니다"
public let CONFIRM =  "확인"
public let CANCEL =  "취소"


//Favorite
public let SOMEONE_LIKED = "내게 끌림을 준 카드"
public let I_LIKED = "내가 호감있는 카드"
public let MATCHING_CHECK_CURRENT_POINT = "상대방에게 채팅요청시 5포인트가 소모됩니다. \n현재 가진 포인트: "
public let NOT_ENOUGH_POINT = "가지고계신 포인트가 부족합니다. \n필요한 포인트: " + String(POINT_USE) + "\n현재 가진 포인트: "


//Stat
public let MY_STAT_RADAR = "나의 이미지 그래프(%)"
public let NEW_UPLOAD = "(새로운 투표 사진 업로드는 왼쪽 사진을 눌러해주세요)"
public let NO_DATA = "현재 투표받은 데이터가 없습니다"
//public let I_LIKED = "내가 호감있는 카드"



class Ref {
    // Storage
    static var STORAGE_ROOT = Storage.storage().reference(forURL: "gs://gleem-dating.appspot.com")
    
    // Storage - Posts
    static var STORAGE_POSTS = STORAGE_ROOT.child("posts")
    static func STORAGE_POST_ID(postId: String) -> StorageReference {
        return STORAGE_POSTS.child(postId)
    }
    
    // Storage - Chat
    static var STORAGE_CHAT = STORAGE_ROOT.child("chat")
    static func STORAGE_CHAT_ID(chatId: String) -> StorageReference {
        return STORAGE_CHAT.child(chatId)
    }
    
    
    // Firestore
    static var FIRESTORE_ROOT = Firestore.firestore()
    
    // Firestore - Users
    static var FIRESTORE_COLLECTION_USERS = FIRESTORE_ROOT.collection("users")
    static func FIRESTORE_DOCUMENT_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_USERS.document(userId)
    }
    
    
    static var FIRESTORE_COLLECTION_TIMELINE = FIRESTORE_ROOT.collection("timeline")
    static func FIRESTORE_TIMELINE_DOCUMENT_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_TIMELINE.document(userId)
    }
    
    static var FIRESTORE_COLLECTION_ALL_POSTS = FIRESTORE_ROOT.collection("all_posts")
    
    
    static var FIRESTORE_COLLECTION_CHAT = FIRESTORE_ROOT.collection("chat")
    static func FIRESTORE_COLLECTION_CHATROOM(senderId: String, recipientId: String) -> CollectionReference {
        return FIRESTORE_COLLECTION_CHAT.document(senderId).collection("chatRoom").document(recipientId).collection("chatItems")
    }
    static var FIRESTORE_COLLECTION_INBOX_MESSAGES = FIRESTORE_ROOT.collection("messages")
    static func FIRESTORE_COLLECTION_INBOX_MESSAGES(userId: String) -> CollectionReference {
        return FIRESTORE_COLLECTION_INBOX_MESSAGES.document(userId).collection("inboxMessages")
    }
    
    static func FIRESTORE_COLLECTION_INBOX_MESSAGES_DOCUMENT_USERID(senderId: String, recipientId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_INBOX_MESSAGES.document(senderId).collection("inboxMessages").document(recipientId)
    }
    
    
    
    
    
    static var FIRESTORE_COLLECTION_FOLLOWING = FIRESTORE_ROOT.collection("following")
    static func FIRESTORE_COLLECTION_FOLLOWING_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_FOLLOWING.document(Auth.auth().currentUser!.uid).collection("userFollowing").document(userId)
    }
    static func FIRESTORE_COLLECTION_FOLLOWING(userId: String) -> CollectionReference {
        return FIRESTORE_COLLECTION_FOLLOWING.document(userId).collection("userFollowing")
    }
    
    
    
    
    static var FIRESTORE_COLLECTION_FOLLOWERS = FIRESTORE_ROOT.collection("followers")
    static func FIRESTORE_COLLECTION_FOLLOWERS_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_FOLLOWERS.document(userId).collection("userFollowers").document(Auth.auth().currentUser!.uid)
    }
    static func FIRESTORE_COLLECTION_FOLLOWERS(userId: String) -> CollectionReference {
        return FIRESTORE_COLLECTION_FOLLOWERS.document(userId).collection("userFollowers")
    }
    
    
    // Storage - Avatar
    static var STORAGE_AVATAR = STORAGE_ROOT.child("avatar")
    static func STORAGE_AVATAR_USERID(userId: String) -> StorageReference {
        return STORAGE_AVATAR.child(userId)
    }
    
    static var STORAGE_VOTE_PIC = STORAGE_ROOT.child("votepictures")
    static func STORAGE_VOTE_PIC_USERID(userId: String) -> StorageReference {
        return STORAGE_VOTE_PIC.child(userId)
    }
    
    
    static var FIRESTORE_COLLECTION_VOTE = FIRESTORE_ROOT.collection("vote")
    static func FIRESTORE_COLLECTION_VOTE_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_VOTE.document(userId)
    }
    
    
    
    static var FIRESTORE_COLLECTION_ACTIVE_VOTE = FIRESTORE_ROOT.collection("active_vote")
    static func FIRESTORE_COLLECTION_ACTIVE_VOTE_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_ACTIVE_VOTE.document(userId)
    }
    
    static var FIRESTORE_COLLECTION_MYVOTE = FIRESTORE_ROOT.collection("myvote")
    static func FIRESTORE_COLLECTION_MYVOTE_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_MYVOTE.document(User.currentUser()!.id).collection("voted").document(userId)
    }
    
    
    static var FIRESTORE_COLLECTION_ATTRIBUTE = FIRESTORE_ROOT.collection("Attributes")
    static func FIRESTORE_COLLECTION_ATTRIBUTE_MALE() -> DocumentReference {
        return FIRESTORE_COLLECTION_VOTE.document("male")
    }
    
    static func FIRESTORE_COLLECTION_ATTRIBUTE_FEMALE() -> DocumentReference {
        return FIRESTORE_COLLECTION_ATTRIBUTE.document("female")
    }
    
    static var FIRESTORE_COLLECTION_SOMEOME_LIKED = FIRESTORE_ROOT.collection("someone_liked")
    static func FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_SOMEOME_LIKED.document(userId)
    }
    
    
    static var FIRESTORE_COLLECTION_ACTIVITY = FIRESTORE_ROOT.collection("activity")
    static func FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_ACTIVITY.document(userId)
    }
    
    
    static var FIRESTORE_COLLECTION_LIKED = FIRESTORE_ROOT.collection("liked")
    static func FIRESTORE_COLLECTION_LIKED_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_LIKED.document(Auth.auth().currentUser!.uid).collection("liked").document(userId)
    }
    
    
    static func FIRESTORE_GET_LIKED_USERID_COLLECTION(userId: String) -> CollectionReference {
        return FIRESTORE_COLLECTION_LIKED.document(userId).collection("liked")
    }
    
    
    
    static var FIRESTORE_COLLECTION_FLAG = FIRESTORE_ROOT.collection("flag")
    static func FIRESTORE_COLLECTION_FLAG_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_FLAG.document(userId)
    }
    
    
    
    static var FIRESTORE_COLLECTION_MATCH = FIRESTORE_ROOT.collection("matched")
    static func FIRESTORE_COLLECTION_MATCH_USERID(userId: String, userId2: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_MATCH.document(userId).collection("matched").document(userId2)
        
    }
    
    //    static func FIRESTORE_GET_VOTE() -> DocumentReference {
    //       return FIRESTORE_COLLECTION_VOTE.document(userId)
    //    }
}
