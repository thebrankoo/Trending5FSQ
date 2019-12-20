//
//  ViewController.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/19/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var segCtrl: UISegmentedControl!
    
    private var viewModel: VenuesViewModel?
    
    private var trendingStackView: UIStackView?
    private var aboutTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VenuesViewModel()
        viewModel?.delegate = self
        viewModel?.run()
    }
    
    @IBAction func segValueChanged(_ sender: Any) {
        if segCtrl.selectedSegmentIndex == 0 {
            setupVenuesView()
        }
        else {
            generateTextView()
        }
    }
    
    private func cleanScrollView() {
        mainScrollView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        mainScrollView.layoutIfNeeded()
    }

}

// MARK: - Trending venues setup
extension MainViewController: VenuesViewModelProtocol {
    func venuesViewModelDidFinishDataLoading() {
        if segCtrl.selectedSegmentIndex == 0 {
            setupVenuesView()
        }
    }
    
    private func setupVenuesView() {
        trendingStackView = generateVenuesView()
        
        if let stackView = trendingStackView {
            cleanScrollView()
            mainScrollView.addSubview(stackView)
            NSLayoutConstraint.activate([
//                stackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
//                stackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
                stackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
                stackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
            ])
            mainScrollView.layoutIfNeeded()
        }
    }
    
    private func generateVenuesView()->UIStackView?  {
        guard let vm = viewModel else {
            return nil
        }
        
        let stackView = createVenuesStackView()
        
        for i in 0..<vm.dataSize {
            let venueView = createVenueView(forIndex: i)
            stackView.addArrangedSubview(venueView)
        }
        stackView.layoutIfNeeded()
        return stackView
    }
    
    private func createVenuesStackView()->UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        return stackView
    }
    
    private func createVenueView(forIndex i: Int)->VenueView {
        let vv = createVenueView()
        vv.translatesAutoresizingMaskIntoConstraints = false
        vv.nameLabel.text = viewModel?.name(atIndex: i)
        vv.addressLabel.text = viewModel?.address(atIndex: i)
        vv.categoryLabel.text = viewModel?.category(atIndex: i)
        vv.layer.cornerRadius = 20.0
        
        return vv
    }
    
    private func createVenueView()->VenueView {
        return VenueView.instanceFromNib()
    }
}

// MARK: - About section setup

extension MainViewController {
    
    func generateTextView() {
        aboutTextView = createAboutTextView()
        aboutTextView?.translatesAutoresizingMaskIntoConstraints = false
        if let textView = aboutTextView {
            cleanScrollView()
            mainScrollView.addSubview(textView)
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
                textView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
                textView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
                textView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
                textView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
            ])
            mainScrollView.layoutIfNeeded()
        }
    }
    
    func createAboutTextView()->UITextView {
        let aboutTextView = UITextView()
        aboutTextView.translatesAutoresizingMaskIntoConstraints = false
        aboutTextView.text =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque et nulla a dui congue porta. Quisque tempor leo sed vestibulum sodales. Sed ut turpis vitae velit consectetur faucibus. Cras rhoncus, lorem eget posuere aliquet, elit elit eleifend orci, non pretium risus elit id mauris. Cras vel sem quam. Aenean vestibulum purus sed massa vulputate semper. Nam luctus faucibus felis, nec aliquet erat iaculis vel. Curabitur pellentesque nunc placerat risus bibendum, a placerat massa ornare. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Quisque lorem nisi, porttitor a ullamcorper nec, gravida et sapien. Vivamus commodo interdum nisl, sit amet pharetra arcu ornare vitae. Sed feugiat commodo libero nec efficitur."
        aboutTextView.font = UIFont(name: aboutTextView.font!.fontName, size: 18)
        aboutTextView.alwaysBounceHorizontal = false
        aboutTextView.isEditable = false
        aboutTextView.isScrollEnabled = false
        return aboutTextView
    }
}
