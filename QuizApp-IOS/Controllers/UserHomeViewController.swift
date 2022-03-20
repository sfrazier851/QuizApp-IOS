//
//  UserHomeViewController.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/17/22.
//

import UIKit

class UserHomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeUserLabel: UILabel!
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    
    @IBOutlet weak var quizCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedQuizPageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupPageControl()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        quizCollectionView.backgroundColor = .systemGroupedBackground
        quizCollectionView.collectionViewLayout = layout
        // snap each cell to fill view (no free scrolling)
        quizCollectionView.isPagingEnabled = true
        quizCollectionView.showsHorizontalScrollIndicator = false
        
        // set the collection view and title initially
        QuizSlide.setSlides(quizzes: Quiz.getAll()!)
        quizTitleLabel.text = QuizSlide.collection[0].title
    }
    
    private func setupPageControl() {
        selectedQuizPageControl.numberOfPages = QuizSlide.collection.count
    }

    private func showTitle(atIndex index: Int) {
        let slide = QuizSlide.collection[index]
        quizTitleLabel.text = slide.title
    }
}

extension UserHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // set number of elements in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        QuizSlide.collection.count
    }
    
    // populate cells with QuizSlide data/images
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // prevents app crashing, worst case is it returns empy collection view cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.ReuseIdentifier.selectQuizCollectionViewCell, for: indexPath) as? SelectQuizCollectionViewCell else { return UICollectionViewCell() }
        
        //cell.backgroundColor = indexPath.item % 2 == 0 ? .systemRed : .systemBlue
        
        let imageName = QuizSlide.collection[indexPath.item].imageName
        let image = UIImage(named: imageName) ?? UIImage()
        cell.configure(image: image)
        
        return cell
    }
    
    // set cell size to fill collection view frame
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    // no space between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // update quiz title and page control
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        showTitle(atIndex: index)
        selectedQuizPageControl.currentPage = index
    }
    
}
