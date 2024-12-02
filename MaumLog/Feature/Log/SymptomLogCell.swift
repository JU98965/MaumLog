//
//  SymptomLogCell.swift
//  MaumLog
//
//  Created by 신정욱 on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SymptomLogCell: UITableViewCell, EditButtonCellType {
    
    static let identifier = "SymptomLogCell"
    private let bag = DisposeBag()

    var delegate: (any EditButtonCellDelegate)?
    var item: (any EditButtonCellModel)?
    
    private let CVCellData = BehaviorSubject<[SymptomCardData]>(value: [])
    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        return formatter
    }()
    
    //MARK: - 컴포넌트
    let overallSV = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fill
        sv.alignment = .center
        return sv
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.text = "오전 12:99"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let deleteButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "multiply.circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 15))
        config.baseForegroundColor = .gray
        config.cornerStyle = .capsule
        let button = UIButton(configuration: config)
        button.isHidden = false
        return button
    }()
    
    let infoCardCV = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        cv.register(RateCardCell.self, forCellWithReuseIdentifier: RateCardCell.identifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.setSinglelineLayout(spacing: 5, width: 100, height: 60)
        return cv
    }()
    
    //MARK: - 라이프 사이클
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setAutoLayout()
        setBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 콘텐츠 뷰 설정
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0))
        contentView.backgroundColor = .chuWhite
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    //MARK: - 오토레이아웃
    private func setAutoLayout(){
        contentView.addSubview(overallSV)
        overallSV.addArrangedSubview(dateLabel)
        overallSV.addArrangedSubview(infoCardCV)
        overallSV.addArrangedSubview(deleteButton)

        overallSV.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        
        dateLabel.snp.makeConstraints { make in
            make.width.equalTo(65)
        }
        infoCardCV.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    //MARK: - 바인드
    private func setBinding() {
        CVCellData
            .bind(to: infoCardCV.rx.items(cellIdentifier: RateCardCell.identifier, cellType: RateCardCell.self)) { index, item, cell in
                cell.setAttributes(item: item)
            }
            .disposed(by: bag)
        
        deleteButton
            .rx.tap
            .bind(onNext: { [weak self] in
                guard let self, let item else { return }
                delegate?.removeTask(item: item)
            })
            .disposed(by: bag)
    }
    
    func setAttributes(item: EditButtonCellModel) {
        guard let item = item as? LogData else { return }
        guard !(item.symptomCards.isEmpty) else { return }
        self.item = item
        
        CVCellData.onNext(item.symptomCards)
        
        dateLabel.text = formatter.string(from: item.date)
        deleteButton.isHidden = !(item.isEditMode)
    }
    
}

#Preview(traits: .fixedLayout(width: 400, height: 100)) {
    SymptomLogCell()
}
