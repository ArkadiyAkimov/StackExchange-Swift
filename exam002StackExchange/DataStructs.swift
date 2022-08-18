
import Foundation

struct UserData: Decodable {
    var items : [UserProfile]
}

struct UserProfile : Decodable {
    var reputation : Int
    var display_name : String
    var profile_image : String
    var user_id : Int
}

struct QuestionData: Decodable {
    var items : [QuestionProfile]
}

struct QuestionProfile : Decodable {
    var link : URL
    var title : String
    var view_count: Int
    var answer_count: Int
    var creation_date: Double
}
