//
//  RatingViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/21/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    private var initialWaveY: CGFloat = 0.0
    private var currentScore: Int = 3 // Start at the midpoint score
    private var hasSetInitialPosition = false // Track if the initial position has been set
    
    // Limit the waveView's position to prevent it from escaping the screen
    private var minY: CGFloat { view.bounds.height * 0.1 } // 10% from the bottom
    private var maxY: CGFloat { view.bounds.height * 0.85 } // 10% from the top

    // MARK: - UI Elements
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .loginBackground)
        imageView.contentMode = .scaleAspectFill
        
        // Add a dimming effect
        let dimmingView = UIView()
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0.5
        
        imageView.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마신 술은\n얼마나 만족스러웠나요?"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var waveView: WaveAnimationView = {
        let wave = WaveAnimationView(
            frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: view.bounds.height)),
            frontColor: UIColor.hex("C2E9FF").withAlphaComponent(0.2),
            backColor: UIColor.hex("FFC6AD").withAlphaComponent(0.2)
        )
        wave.waveHeight = 10
        wave.startAnimation()
        wave.progress = 1.0
        return wave
    }()
    
    // Ruler View
    lazy var rulerView: RulerView = {
        let ruler = RulerView()
        ruler.backgroundColor = .clear
        ruler.labels = ["awesome", "very good!", "good", "Not bad", "umm.."]
        return ruler
    }()
    
    lazy var previousButton: UIButton = {
        let button = BlurredButton()
        button.setTitle("이전", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = BlurredButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousButton, nextButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        addPanGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasSetInitialPosition {
            setInitialWavePosition() // Set the initial position at the midpoint (3 score)
            hasSetInitialPosition = true // Ensure this only runs once
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(waveView)
        view.addSubview(titleLabel)
        view.addSubview(buttonStackView)
        view.addSubview(rulerView)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view).inset(16)
        }
        
        waveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.width.height.equalToSuperview()
        }
        
        rulerView.snp.makeConstraints { make in
            make.trailing.equalTo(view)
            make.top.equalTo(view.snp.top).offset(minY) // Align with scale start
            make.bottom.equalTo(view.snp.bottom).inset(view.bounds.height - maxY) // Align with scale end
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }
    private func setInitialWavePosition() {
        view.layoutIfNeeded()

        // Set the wave view's y position to the middle of the allowable range
        let midY = (minY + maxY) / 2
        waveView.frame.origin.y = midY
        initialWaveY = midY
        updateScore(for: midY)
    }
    
    // MARK: - Gesture Handling
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        // Adjust the wave's vertical position based on the finger's position
        if gesture.state == .began {
            initialWaveY = waveView.frame.origin.y
        } else if gesture.state == .changed {
            let newY = initialWaveY + translation.y
            waveView.frame.origin.y = max(minY, min(newY, maxY))
            updateScore(for: waveView.frame.origin.y)
            waveView.setNeedsDisplay() // Redraw the wave with the new position
        } else if gesture.state == .ended || gesture.state == .cancelled {
            gesture.setTranslation(.zero, in: view)
        }
    }
    
    // MARK: - Scoring Logic
    
    private func updateScore(for waveY: CGFloat) {
        let normalizedPosition = (waveY - minY) / (maxY - minY)
        currentScore = Int(round(normalizedPosition * 4)) + 1
    }
    
    // MARK: - Actions
    
    @objc private func didTapPreviousButton() {
        // Handle previous button tap
    }
    
    @objc private func didTapNextButton() {
        // Handle next button tap
    }
}

import SwiftUI
#Preview {
    RatingViewController.preview()
}
