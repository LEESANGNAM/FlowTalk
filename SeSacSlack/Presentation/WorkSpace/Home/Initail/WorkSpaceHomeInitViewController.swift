//
//  WorkSpaceHomeInitViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/15/24.
//

import UIKit
import RxSwift
import RxCocoa

enum testsection: Int {
    case channel
    case directmessage
    case addMember
    
    var title: String {
        switch self {
        case .channel:
            return "채널"
        case .directmessage:
            return "다이렉트 메시지"
        case .addMember:
            return "팀원추가"
        }
    }
}

class WorkSpaceHomeInitViewController: BaseViewController {
    let testData = [
    ["일반","채널1","채널2","채널3","채널4","채널5","채널6","채널7","채널8","채널9","채널추가"],
    ["사람1","사람2","사람3","사람4","사람5","사람6","사람7","사람8","사람9","사람10","사람11"],
    ["팀원추가"]
    ]
    
    var hiddenSections = Set<Int>()
    let workSpaceNaviBar = WorkSpaceProfileView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func setHierarchy() {
        view.addSubview(workSpaceNaviBar)
        view.addSubview(tableView)
    }
    override func setConstraint() {
        workSpaceNaviBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(46)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(workSpaceNaviBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

extension WorkSpaceHomeInitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.testData.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return section == 2 ? 0 : 44
       }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2{
            return nil
        }
        
        let sectionButton = UIButton()
        sectionButton.setTitle(testsection(rawValue: section)?.title,for: .normal)
        sectionButton.backgroundColor = .black
        sectionButton.tag = section
        sectionButton.addTarget(self, action: #selector(self.hideSection(sender:)), for: .touchUpInside)

        return sectionButton
    }
    
    @objc
    private func hideSection(sender: UIButton) {
        // section의 tag 정보를 가져와서 어느 섹션인지 구분한다.
        let section = sender.tag
        
        // 특정 섹션에 속한 행들의 IndexPath들을 리턴하는 메서드
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            for row in 0..<self.testData[section].count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            return indexPaths
        }
        
        // 가져온 section이 원래 감춰져 있었다면
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(), with: .fade)
            // 섹션을 노출시킬때 원래 감춰져 있던 행들이 다 보일 수 있게 한다.
            self.tableView.scrollToRow(at: IndexPath(row: self.testData[section].count - 1,
                            section: section), at: UITableView.ScrollPosition.bottom, animated: true)
        } else {
            // section이 원래 노출되어 있었다면 행들을 감춘다.
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 섹션이 hidden이므로 행을 노출시키지 않는다.
        if self.hiddenSections.contains(section) {
            return 0
        }
        // 가진 데이터의 개수만큼 노출시킨다.
        return testData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = testData[indexPath.section][indexPath.row]
            
        return cell
    }
    
    
}
