//
//  RatingViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/21/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class RatingViewController: UIViewController {
    var viewModel: RatingViewModel!
    
    private var initialWaveY: CGFloat = 0.0
    private var currentScore: Int = 3 // Start at the midpoint score
    private var hasSetInitialPosition = false // Track if the initial position has been set
    
    // Limit the waveView's position to prevent it from escaping the screen
    private var minY: CGFloat { view.bounds.height * 0.15 } // 15% from the top
    private var maxY: CGFloat { view.bounds.height * 0.8 } // 20% from the bottom
    private var scorePositions: [CGFloat] = [] // Array to hold the Y positions for each score

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
    
    lazy var tooltipView: UILabel = {
        let label = UILabel()
        label.text = "만족한만큼 채워주세요!"
        label.font = .pretendard(size: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        
        label.layer.backgroundColor = UIColor.hex("5d6163").cgColor
        label.layer.cornerRadius = 10
        label.isHidden = true // Initially hidden
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마신 술은\n얼마나 만족스러웠나요?"
        label.font = .pretendard(size: 20, weight: .semibold)
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
        ruler.labelInformations = RulerView.LabelInformation(
            ("awesome", UIImage(resource: .flushedFace)),
            ("very good!", UIImage(resource: .faceIcon)),
            ("good", UIImage(resource: .faceIcon)),
            ("Not bad", UIImage(resource: .faceIcon)),
            ("umm..", UIImage(resource: .faceIcon))
        )
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
            calculateScorePositions()
            hasSetInitialPosition = true // Ensure this only runs once
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTooltipWithAnimation()
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(waveView)
        view.addSubview(titleLabel)
        view.addSubview(buttonStackView)
        view.addSubview(rulerView)
        view.addSubview(tooltipView)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view).inset(16)
        }
        
        rulerView.snp.makeConstraints { make in
            make.trailing.equalTo(view)
            make.top.equalTo(view.snp.top).offset(minY)
            make.bottom.equalTo(view.snp.bottom).inset(view.bounds.height - maxY)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        
        tooltipView.snp.makeConstraints { make in
            make.width.equalTo(310)
            make.height.equalTo(51)
            make.center.equalToSuperview()
        }
    }

    private func setInitialWavePosition() {
        view.layoutIfNeeded()

        // Set the wave view's y position to the middle of the allowable range
        let midY = (minY + maxY) / 2
        waveView.frame.origin.y = midY
        initialWaveY = midY
        updateScore(for: midY)
        
        // Showing label image for the first time
        rulerView.triggerEvent(at: .three)
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
            snapToNearestScore() // Snap to the nearest score position
            gesture.setTranslation(.zero, in: view)
        }
    }

    // MARK: - Snap to Nearest Score
    
    private func snapToNearestScore() {
        // Find the nearest score position
        let closestPosition = scorePositions.min(by: {
            abs($0 - waveView.frame.origin.y) < abs($1 - waveView.frame.origin.y)
        }) ?? initialWaveY
        
        // Animate the waveView to snap to the nearest position
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1.0,
            options: .curveEaseOut,
            animations: {
                self.waveView.frame.origin.y = closestPosition
            })
        
        // Update the score based on the snapped position
        updateScore(for: closestPosition)
        
        switch currentScore {
            case 1: rulerView.triggerEvent(at: .one)
            case 2: rulerView.triggerEvent(at: .two)
            case 3: rulerView.triggerEvent(at: .three)
            case 4: rulerView.triggerEvent(at: .four)
            case 5: rulerView.triggerEvent(at: .five)
            default: break
        }
        
        // Give haptic effect
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    // MARK: - Scoring Logic

    private func calculateScorePositions() {
        // Calculate the Y positions corresponding to each score
        scorePositions = [
            minY,                                // 1st score position
            minY + (maxY - minY) * 0.25,         // 2nd score position
            minY + (maxY - minY) * 0.5,          // 3rd score position (midpoint)
            minY + (maxY - minY) * 0.75,         // 4th score position
            maxY                                 // 5th score position
        ]
    }
    
    private func updateScore(for waveY: CGFloat) {
        // Calculate the current score based on the Y position of the waveView
        let normalizedPosition = (waveY - minY) / (maxY - minY)
        currentScore = Int(round(normalizedPosition * 4)) + 1
    }
    
    // MARK: - Tooltip Animation
    
    private func showTooltipWithAnimation() {
        tooltipView.isHidden = false
        tooltipView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        tooltipView.alpha = 0
        
        // Show with popping animation
        UIView.animate(
            withDuration: 0.5,
            delay: 0.5,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: {
                self.tooltipView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.tooltipView.alpha = 1.0
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.hideTooltipWithAnimation()
                }
            }
    }
    
    private func hideTooltipWithAnimation() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: {
                self.tooltipView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.tooltipView.alpha = 0
            }) { _ in
                self.tooltipView.isHidden = true
            }
    }
    
    // MARK: - Actions
    
    @objc private func didTapPreviousButton() {
        // Handle previous button tap
    }
    
    @objc private func didTapNextButton() {
        viewModel.updateScore(currentScore)
    }
}

import SwiftUI
#Preview {
    RatingViewController.preview {
        let vc = RatingViewController()
        vc.viewModel = .init()
        return vc
    }
}
