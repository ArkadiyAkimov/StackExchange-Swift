//
//  ViewController.swift
//  exam002StackExchange
//
//  Created by Arkadiy Akimov on 17/08/2022.
//

import UIKit

class ViewController: UIViewController {

    var userAvatarView = UIImageView()
    var nameLabel = UILabel()
    var reputationValue = UILabel()
    var searchUserQuestionData = [QuestionProfile]()
    var totalQuestionsFound = UILabel()
    var activityIndicators = [UIActivityIndicatorView]()
    var errorLabel = UILabel()
    let webPage = questionWebView()
    
    var tableView : UITableView = {
        let table = UITableView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.userRepo.subscribe(self)
        Service.questionsRepo.subscribe(self)
        configureThemeSwitch()
        configureTitleLabel()
        configureSearchTextField()
        hideKeyboardWhenTappedAround()
        configureUserDetailsView()
        configureQuestionsSortMenu()
        configureTableView()
        configureTotalQuestionsFound()
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.userAvatarView.image = UIImage(data: data)
            }
        }
    }
    
    func configureThemeSwitch(){
        let switchView = UIView(frame: CGRect(x: view.bounds.width - 70, y: 50,width: 50, height: 50))
        //switchView.backgroundColor = .red
        let themeSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        themeSwitch.setOn(true, animated: false)
        let switchLabel = UILabel(frame: CGRect(x: 0, y: 30, width: 50, height: 20))
        switchLabel.text = "light mode"
        switchLabel.textAlignment = .center
        switchLabel.font = UIFont.systemFont(ofSize: 16)
        switchLabel.adjustsFontSizeToFitWidth = true
        switchView.addSubview(switchLabel)
        switchView.addSubview(themeSwitch)
        view.addSubview(switchView)
        themeSwitch.addTarget(self, action: #selector(themeSwitchClick(_:)), for: .valueChanged)
    }
    
    @objc func themeSwitchClick(_ sender:UISwitch){
        switch sender.isOn {
        case true:
            print("on")
            UIWindow.animate(withDuration: 0.5, delay: 0) {
                self.overrideUserInterfaceStyle = .light
            }
            break
        case false:
            print("off")
            UIWindow.animate(withDuration: 0.5, delay: 0) {
                self.overrideUserInterfaceStyle = .dark
            }
            break
        }
    }
    
    func configureTitleLabel(){
        let titleLabel = UILabel(frame: CGRect(x: 30, y: 100, width: view.bounds.width-60, height: 50))
        titleLabel.text = "Get Stack Overflow Posts"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    func configureSearchTextField(){
        let searchTextField = UISearchBar(frame: CGRect(x: 30, y: 150, width: view.bounds.width - 60 , height: 50))
        searchTextField.delegate = self
        searchTextField.placeholder = "User ID"
        view.addSubview(searchTextField)
        
    }
    
    func configureUserDetailsView() {
        let userDetailsView = UIView(frame: CGRect(x: 40, y: 200 , width: view.bounds.width - 80, height: 200))
        //userDetailsView.backgroundColor = .red
        view.addSubview(userDetailsView)
        
        errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 80, height: 20))
        errorLabel.text = ""
        errorLabel.textColor = .red
        userDetailsView.addSubview(errorLabel)
        
        userAvatarView = UIImageView(frame: CGRect(x: 0, y: (userDetailsView.bounds.height - userDetailsView.bounds.width/3) / 2, width: userDetailsView.bounds.width/3 * 1, height: userDetailsView.bounds.width/3 * 1))
        userAvatarView.layer.borderColor = UIColor.black.cgColor
        userAvatarView.layer.borderWidth = 5
        userAvatarView.layer.cornerRadius = 10
        userAvatarView.image = UIImage(systemName: "person.fill")
        userAvatarView.tintColor = .black
        userAvatarView.clipsToBounds = true
        userAvatarView.contentMode = .scaleAspectFill
        userDetailsView.addSubview(userAvatarView)
        
        activityIndicators.append(UIActivityIndicatorView(frame: userAvatarView.bounds))
        activityIndicators[0].hidesWhenStopped = true
        userAvatarView.addSubview(activityIndicators[0])
        
        let VStack = UIStackView(frame: CGRect(x: userDetailsView.bounds.width/3 + 20 , y: (userDetailsView.bounds.height - userDetailsView.bounds.width/3)/2 , width: userDetailsView.bounds.width/3 * 2 - 20, height: userDetailsView.bounds.width/3 * 1))
        VStack.axis = .vertical
        VStack.distribution = .fillProportionally
        userDetailsView.addSubview(VStack)
        
        nameLabel = UILabel()
        nameLabel.text = "Display Name"
        let reputationLabel = UILabel()
        reputationLabel.text = "Reputation"
        reputationValue = UILabel()
        reputationValue.text = "0"
        
        VStack.addArrangedSubview(nameLabel)
        VStack.addArrangedSubview(reputationLabel)
        VStack.addArrangedSubview(reputationValue)
    }
    
    func configureQuestionsSortMenu(){
        let HStack = UIStackView(frame: CGRect(x: 50, y: 400, width: view.bounds.width - 100, height: 30))
        HStack.distribution = .fillProportionally
        let questionsLabel = UILabel()
        questionsLabel.adjustsFontSizeToFitWidth = true
        questionsLabel.text = "Questions: "
        let questionSortMenu = UISegmentedControl(items: ["date","answers","views"])
        questionSortMenu.backgroundColor = .systemGray5
        questionSortMenu.selectedSegmentTintColor = .systemBlue
        questionSortMenu.layer.borderWidth = 2
        questionSortMenu.addTarget(self, action: #selector(questionSortChange(_:)), for: .valueChanged)
        
        view.addSubview(HStack)
        HStack.addArrangedSubview(questionsLabel)
        HStack.addArrangedSubview(questionSortMenu)
    }
    
    @objc func questionSortChange(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("sort by date")
            searchUserQuestionData.sort(by: { $0.creation_date > $1.creation_date })
            break
        case 1:
            print("sort by answers count")
            searchUserQuestionData.sort(by: { $0.answer_count > $1.answer_count })
            break
        case 2:
            print("sort by views count")
            searchUserQuestionData.sort(by: { $0.view_count > $1.view_count })
            break
        default:
            break
        }
        tableView.reloadData()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .gray
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 30, y: 460, width: view.bounds.width - 60, height: view.bounds.height - 550)
        view.addSubview(tableView)
        
        activityIndicators.append(UIActivityIndicatorView(frame: tableView.bounds))
        activityIndicators[1].hidesWhenStopped = true
        tableView.addSubview(activityIndicators[1])
    }
    
    func configureTotalQuestionsFound(){
        totalQuestionsFound = UILabel(frame: CGRect(x: 40, y: view.bounds.height - 60, width: view.bounds.width - 80 , height: 20))
        totalQuestionsFound.text = "Total of 0 questions found"
        view.addSubview(totalQuestionsFound)
    }
    
    func animateActivityIndicators(){
        for indicator in activityIndicators {
            indicator.startAnimating()
    }
  }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        animateActivityIndicators()
        Service.userRepo.searchName = (searchBar.searchTextField.text ?? "").replacingOccurrences(of: " ", with: "_")
        Service.userRepo.fetchUserData()
        dismissKeyboard()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        errorLabel.text = ""
        view.endEditing(true)
    }
}


