//
//  AverageRateCalendarView.swift
//  MaumLog
//
//  Created by 신정욱 on 8/19/24.
//

import UIKit
import SnapKit

final class AverageRateCalendarView: UIView {
    //MARK: - 컴포넌트
    let overallSV = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = .zero
        sv.distribution = .fill
        sv.backgroundColor = .chuWhite
        sv.clipsToBounds = true
        sv.layer.cornerRadius = 15
        return sv
    }()
    
    let titleSV = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = .zero
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        return sv
    }()
    
    let divider0 = DividerView(lineWidth: 1, lineColor: .chuIvory)
    
    let titleLabel = {
        let label = UILabel()
        label.text = String(localized: "평균 부작용 척도")
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .chuBlack
        label.backgroundColor = .clear
        return label
    }()
    
    let calendarView = {
        let view = UICalendarView()
        // 달력 커스텀을 위해 설정해 주어야 하는 속성
        view.wantsDateDecorations = true
        view.fontDesign = .rounded
        view.tintColor = .chuTint
        return view
    }()
    
    let tipLabelSV = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = .init(top: 10, leading: 7.5, bottom: 7.5, trailing: 10)
        return sv
    }()
    
    let tipLabel = {
        let label = UILabel()
        label.text = String(localized: "* 기타 증상 항목은 계산에 포함되지 않아 \"없음\"으로 표시될 수 있습니다.")
        label.font = .boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .lightGray
        return label
    }()
    
    
    //MARK: - 라이프 사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 오토레이아웃
    private func setAutoLayout() {
        self.addSubview(overallSV)

        overallSV.addArrangedSubview(titleSV)
        overallSV.addArrangedSubview(divider0)
        overallSV.addArrangedSubview(calendarView)
        overallSV.addArrangedSubview(tipLabelSV)
        
        titleSV.addArrangedSubview(titleLabel)
        tipLabelSV.addArrangedSubview(tipLabel)

        
        overallSV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


#Preview(traits: .fixedLayout(width: 400, height: 600)) {
    AverageRateCalendarView()
}
