//
//  CoursesViewCotroller.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import UIKit

class CoursesViewCotroller: UIViewController, Loading {

    // MARK: Constants

    private let apiClient = APIClient.shared

    private enum Segue: String {
        case openSlideShow
    }

    enum CourcePart {
        case module(m: CourseModule)
        case segment(s: CourseModuleSegment)
        case notFound
    }

    // MARK: Outlets

    @IBOutlet weak var coursesTableView: UITableView!

    // MARK: Properties

    var courses = [Course]()

    // MARK: Loading

    var isLoading: Bool = false
    var loadingIndicator = UIView.loadingIndicator()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        userCourses()
    }

    // MARK: Courses

    private func userCourses() {
        view.isUserInteractionEnabled = false

        apiClient.userCourses(
        sender: self) { [weak self] result in

            guard let strongSelf = self else {
                return
            }

            strongSelf.view.isUserInteractionEnabled = true

            switch result {
            case .success(let courseIds):
                for course in courseIds {
                    strongSelf.course(course.id)
                }

            case .failure(let error):
                strongSelf.handleRequestError(error)
            }
        }
    }

    private func course(_ id: Int) {
        view.isUserInteractionEnabled = false

        apiClient.course(
        id: id,
        sender: self) { [weak self] result in

            guard let strongSelf = self else {
                return
            }

            strongSelf.view.isUserInteractionEnabled = true

            switch result {
            case .success(let course):
                let courseWithLecturesOnly = strongSelf.lecturesOnly(
                    from: course)

                strongSelf.courses.append(courseWithLecturesOnly)
                strongSelf.coursesTableView.reloadData()

            case .failure(let error):
                strongSelf.handleRequestError(error)
            }
        }
    }

    private func lectureSegment(id: Int, courseId: Int) {
        view.isUserInteractionEnabled = false

        apiClient.lectureSegment(
            lectureSegmentId: id,
            courseId: courseId,
            sender: self) { [weak self] result in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.view.isUserInteractionEnabled = true

                switch result {
                case .success(let lecture):
                    strongSelf.openSlideShow(lecture.slideShowUrl)

                case .failure(let error):
                    strongSelf.handleRequestError(error)
                }
        }
    }

    // MARK: Segue

    func openSlideShow(_ url: String) {
        performSegue(
            withIdentifier: Segue.openSlideShow.rawValue,
            sender: url)
    }

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?) {

        guard let identifier = segue.identifier else {
            return
        }

        switch identifier {
        case Segue.openSlideShow.rawValue:
            guard let slideShowVC = segue.destination
                as? SlideShowViewController else {
                    return
            }

            guard let slideShowUrl = sender as? String else {
                return
            }

            slideShowVC.slideShowUrl = slideShowUrl

        default:
            break
        }
    }

    // MARK: Helpers

    func coursePart(for indexPath: IndexPath) -> (CourcePart) {
        let course = courses[indexPath.section]
        let row = indexPath.row

        var count = 0
        for m in course.modules {
            if row == count {
                return (.module(m: m))
            }

            count += 1
            for s in m.segments {
                if count == row {
                    return (.segment(s: s))
                }

                count += 1
            }
        }

        return (.notFound)
    }

    func lecturesOnly(from course: Course) -> Course {
        var lecturesOnlyCourse = course

        for i in 0..<course.modules.count {
            let m = course.modules[i]

            for j in 0..<m.segments.count {
                let s = m.segments[j]

                if s.type != "ContentLibrary::LectureSegment" {
                    let module = lecturesOnlyCourse.modules[i]
                    if let index = module.segments.index(of: s) {
                        lecturesOnlyCourse.modules[i].segments.remove(at: index)
                    }
                }
            }
        }

        var noEmptyModulesCourse = lecturesOnlyCourse
        for i in 0..<lecturesOnlyCourse.modules.count {
            let m = lecturesOnlyCourse.modules[i]

            if m.segments.count == 0 {
                if let index = noEmptyModulesCourse.modules.index(of: m) {
                    noEmptyModulesCourse.modules.remove(at: index)
                }
            }
        }

        return noEmptyModulesCourse
    }
}

// MARK: - UITableViewDelegate

extension CoursesViewCotroller: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ModuleCell.cellHeight
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let (part) = coursePart(for: indexPath)

        switch part {
        case .segment(let s):
            lectureSegment(
                id: s.id,
                courseId: courses[indexPath.section].id)

        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension CoursesViewCotroller: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return courses.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        var rowsNumber = courses[section].modules.count
        for module in courses[section].modules {
            rowsNumber += module.segments.count
        }
        return rowsNumber
    }

    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {

        return courses[section].title
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (part) = coursePart(for: indexPath)

        switch part {
        case .module(let m):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ModuleCell.cellId) else {
                    return UITableViewCell()
            }

            cell.textLabel?.text = m.title
            return cell

        case .segment(let s):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LectureSegmentCell.cellId) as? LectureSegmentCell else {
                    return UITableViewCell()
            }

            cell.segmentTitleLabel.text = s.name
            return cell

        case .notFound:
            return UITableViewCell()
        }
    }
}
