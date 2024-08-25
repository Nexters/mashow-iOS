import UIKit
import SnapKit

class RulerView: UIView {
    var labels: [String] = [] // Array to store labels for highlighted ticks
    var labelImages: [UIImage] = [
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "star.fill")!
    ] // Array to store label images for highlighted ticks
    
    private var imageViewArray: [UIImageView] = [] // Store references to image views
    
    enum Level {
        case one, two, three, four, five
    }
    
    func triggerEvent(at level: Level) {
        // Adjust the UI based on the selected level
        switch level {
        case .one:
            highlightLevel(at: 0)
        case .two:
            highlightLevel(at: 1)
        case .three:
            highlightLevel(at: 2)
        case .four:
            highlightLevel(at: 3)
        case .five:
            highlightLevel(at: 4)
        }
    }
    
    private func createImageViewsIfNeeded() {
        if imageViewArray.isEmpty, labelImages.count >= 5 {
            for i in 0...4 {
                let imageView = UIImageView()
                imageView.image = labelImages[i]
                imageView.contentMode = .scaleAspectFit
                imageView.isHidden = true
                imageViewArray.append(imageView)
            }
            
            print("Added image views")
        }
    }
    
    private func highlightLevel(at index: Int) {
        createImageViewsIfNeeded()
        
        // Hide all images
        imageViewArray.forEach { $0.isHidden = true }
        
        // Unhide the image at the selected level
        imageViewArray[index].isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Clear any previous subviews and reset imageViewArray
        self.subviews.forEach { $0.removeFromSuperview() }
        
        // Calculate the spacing and setup the ruler
        let tickHeight: CGFloat = 8.0  // Height of the tick marks
        let tickSpacing: CGFloat = bounds.height / 20  // Spacing between ticks
        
        createImageViewsIfNeeded()

        // Adjusted loop to ensure the bottommost tick is included
        for i in 0...20 {
            let yPosition = CGFloat(i) * tickSpacing
            
            // Create an HStack for each tick and label pair
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.alignment = .center
            hStack.spacing = 8  // Spacing between image, label, and tick
            
            
            if i % 5 == 0, i / 5 < labelImages.count {
                // Add image, label, and tick for every 5th tick
                let imageView = imageViewArray[i / 5]
                hStack.addArrangedSubview(imageView)
                
                // Set constraints for the imageView
                imageView.snp.makeConstraints { make in
                    make.width.height.equalTo(24) // Adjust size as needed
                }
            }

            if i % 5 == 0, i / 5 < labels.count {
                let label = UILabel()
                label.text = labels[i / 5]
                label.font = .systemFont(ofSize: 16, weight: .semibold)
                label.textColor = UIColor.hex("909090")
                hStack.addArrangedSubview(label)
            }
            
            // Create the tick view
            let tickView = UIView()
            tickView.backgroundColor = (i % 5 == 0) ? UIColor.lightGray : UIColor.lightGray.withAlphaComponent(0.5)
            hStack.addArrangedSubview(tickView)
            
            if i % 5 == 0 {
                // Highlighted tick
                tickView.snp.makeConstraints { make in
                    make.width.equalTo(tickHeight)
                }
            } else {
                // Regular tick
                tickView.snp.makeConstraints { make in
                    make.width.equalTo(tickHeight / 2)
                }
            }
            tickView.snp.makeConstraints { make in
                make.height.equalTo(1)  // Set tick height (thickness)
            }
            
            // Add the hStack to the view
            addSubview(hStack)
            
            // Position the hStack using SnapKit
            hStack.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview().offset(yPosition - bounds.height / 2)
            }
        }
    }
}
