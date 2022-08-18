//
//  AppData.swift
//  exam002StackExchange
//
//  Created by Arkadiy Akimov on 18/08/2022.
//

import UIKit
import Alamofire

struct Service {
    static var userRepo = UserRepository()
    static var questionsRepo = QuestionRepository()
}

class UserRepository {
    var userData : UserData!
    var subscribers = [UserDataDelagate]()
    
    var searchName : String = ""
    
    func subscribe(_ sender: UserDataDelagate){
        subscribers.append(sender)
    }
    
    func updateUserData(){
        for subscriber in subscribers {
            subscriber.onUserDataUpdate()
        }
    }
    
    func failureToUpdateUserData(){
        for subscriber in subscribers {
            subscriber.onUserDataUpdateFailure()
        }
    }
    
    func fetchUserData(){
        print("Searching: \(searchName)")
        AF.request("https://api.stackexchange.com/2.3/users?order=desc&sort=reputation&inname=\(searchName)&site=stackoverflow")
            .validate()
            .responseDecodable(of: UserData.self ) { response in
                switch response.result {
                case .success(let value):
                    if value.items.count > 0 {
                     self.userData = value
                     self.updateUserData()
                    } else {
                        print(value.items.count)
                        self.failureToUpdateUserData()
                    }
                    break
                case .failure:
                    print("Failure fetching user data:",response.error.debugDescription)
                    self.failureToUpdateUserData()
                    break
                }
            }
    }
}

class QuestionRepository {
    var questionData: QuestionData!
    var subscribers = [QuestionDataDelegate]()
    
    var searchUserId : Int = 0
    
    func subscribe(_ sender: QuestionDataDelegate){
        subscribers.append(sender)
    }
    
    func updateQuestionData(){
        for subscriber in subscribers {
            subscriber.onQuestionDataUpdate()
        }
    }
    
    func fetchQuestionData(){
        AF.request("https://api.stackexchange.com/2.3/users/\(searchUserId)/questions?order=desc&sort=activity&site=stackoverflow")
            .validate()
            .responseDecodable(of: QuestionData.self) { response in
                switch response.result {
                case .success(let value):
                    self.questionData = value
                    self.updateQuestionData()
                    break
                case .failure:
                    print("Failure fetching question data:",response.error.debugDescription)
                    break
                }
            }
    }
}

protocol UserDataDelagate {
    func onUserDataUpdate()
    func onUserDataUpdateFailure()
}

protocol QuestionDataDelegate {
    func onQuestionDataUpdate()
}
