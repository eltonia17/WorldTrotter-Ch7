//
//  ViewController.swift
//  Quiz
//
//  Created by Eltonia Leonard on 9/26/25.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!

    // Use localized keys instead of hardcoded English
    let questions: [String] = [
        NSLocalizedString("quiz.q1", comment: "Question 1"),
        NSLocalizedString("quiz.q2", comment: "Question 2"),
        NSLocalizedString("quiz.q3", comment: "Question 3")
    ]

    let answers: [String] = [
        NSLocalizedString("quiz.a1", comment: "Answer 1"),
        NSLocalizedString("quiz.a2", comment: "Answer 2"),
        NSLocalizedString("quiz.a3", comment: "Answer 3")
    ]

    var currentQuestionIndex: Int = 0

    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count { currentQuestionIndex = 0 }

        questionLabel.text = questions[currentQuestionIndex]
        answerLabel.text = "???"  
    }

    @IBAction func showAnswer(_ sender: UIButton) {
        answerLabel.text = answers[currentQuestionIndex]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
}
