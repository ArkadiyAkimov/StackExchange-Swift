//
//  ViewController+UserDataDelegate+QuestionDataDelegate.swift
//  exam002StackExchange
//
//  Created by Arkadiy Akimov on 18/08/2022.
//

import UIKit

extension ViewController : UserDataDelagate, QuestionDataDelegate {
    func onUserDataUpdate() {
        let user = Service.userRepo.userData.items[0]
        print(user.display_name)
        print(user.reputation)
        print("User id:",user.user_id)
        
        self.nameLabel.text = user.display_name
        self.reputationValue.text = String(user.reputation)
        self.downloadImage(from: URL(string: user.profile_image)!)
        Service.questionsRepo.searchUserId = user.user_id
        Service.questionsRepo.fetchQuestionData()
        
        activityIndicators[0].stopAnimating()
        errorLabel.text = ""
    }
    
    func onUserDataUpdateFailure() {
        activityIndicators[0].stopAnimating()
        activityIndicators[1].stopAnimating()
        print("no user found")
        errorLabel.text = "user not found"
    }
    
    func onQuestionDataUpdate() {
        let questions = Service.questionsRepo.questionData.items
        print("questions count:",questions.count)
        self.searchUserQuestionData = questions
        self.totalQuestionsFound.text = "Total of \(questions.count) questions found"
        self.tableView.reloadData()
        
        activityIndicators[1].stopAnimating()
    }
    
    
}
