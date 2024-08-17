import UIKit
import SnapKit

class ViewToggleStackView: UIView {
    enum SelectableType {
        case card, list
    }
    
    // MARK: - Properties
    var onTapCardView: (() -> Void)?
    var onTapListView: (() -> Void)?

    // MARK: - UI Elements

    lazy var cardViewButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .darkGray
        configuration.cornerStyle = .capsule
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.configurationUpdateHandler = { btn in
            btn.configuration?.attributedTitle = AttributedString(
                "Card view",
                attributes: AttributeContainer([.font: UIFont.pretendard(size: 14, weight: .semibold)]))
        }
        button.addTarget(self, action: #selector(didTapCardView), for: .touchUpInside)
        return button
    }()
    
    lazy var listViewButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .darkGray
        configuration.cornerStyle = .capsule
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.configurationUpdateHandler = { btn in
            btn.configuration?.attributedTitle = AttributedString(
                "List view",
                attributes: AttributeContainer([.font: UIFont.pretendard(size: 14, weight: .semibold)]))
        }
        button.addTarget(self, action: #selector(didTapListView), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardViewButton, listViewButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        // FIXME: Not MVP
        cardViewButton.alpha = 0.4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    private func setupViews() {
        addSubview(stackView)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapCardView() {
        onTapCardView?()
    }
    
    @objc
    private func didTapListView() {
        onTapListView?()
    }
}
