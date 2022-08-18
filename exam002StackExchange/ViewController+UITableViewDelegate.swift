
import UIKit

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        webPage.questionURL = Service.questionsRepo.questionData.items[indexPath.row].link
        present(webPage, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUserQuestionData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let VStack = UIStackView(frame: CGRect(x: 10, y: 5, width: view.bounds.width - 110 , height: 100 - 10 ))
        VStack.axis = .vertical
        VStack.distribution = .fillProportionally
        
        let questionTitle = UILabel()
        questionTitle.text = "Question title"
        questionTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        questionTitle.numberOfLines = -1
        questionTitle.adjustsFontSizeToFitWidth = true
        questionTitle.text = searchUserQuestionData[indexPath.row].title
        
        let questionSubtitle = UILabel()
        questionSubtitle.text = "question subtitle"
        questionSubtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        questionSubtitle.textColor = .systemGray
        questionSubtitle.numberOfLines = -1
        questionSubtitle.adjustsFontSizeToFitWidth = true
        
        let int = searchUserQuestionData[indexPath.row].creation_date
        let date = Date(timeIntervalSince1970: int)
        let format = date.getFormattedDate(format: "dd/MM/yyyy")
        
        questionSubtitle.text = "date: \(format)  views: \(searchUserQuestionData[indexPath.row].view_count)  answers: \(searchUserQuestionData[indexPath.row].answer_count)"
        cell.addSubview(VStack)
        VStack.addArrangedSubview(questionTitle)
        VStack.addArrangedSubview(questionSubtitle)
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.frame = CGRect(x: view.bounds.width - 90, y: 0, width: 20, height: 100)
        chevron.contentMode = .center
        chevron.tintColor = .systemGray
        cell.addSubview(chevron)
        
        return cell
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
