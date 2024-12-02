//
//  AddVC.swift
//  MaumLog
//
//  Created by 신정욱 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AddLogVC: UIViewController {
    
    private let addLogVM = AddLogVM()
    private let bag = DisposeBag()
    var dismissTask: (() -> Void)?
    
    //MARK: - 컴포넌트
    let titleBackground = {
        let view = UIView()
        view.backgroundColor = .chuIvory
        return view
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.text = String(localized: "새 기록 추가")
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .chuBlack
        label.textAlignment = .center
        return label
    }()
    
    let closeButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "x")?
            .resizeImage(newWidth: 22)
            .withRenderingMode(.alwaysTemplate)
        config.baseForegroundColor = .chuBlack
        return UIButton(configuration: config)
    }()
    
    let pendingLogTV = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(PendingLogCell.self, forCellReuseIdentifier: PendingLogCell.identifier)
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        tv.showsVerticalScrollIndicator = false
        tv.clipsToBounds = false
        return tv
    }()
    
    let pendingLogEmptyView = {
        let view = EmptyView(
            text: String(localized: "증상 버튼을 눌러 기록을 추가할 수 있어요."),
            textSize: 14,
            image: UIImage(named: "addList"),
            spacing: 20)
        
        view.label.textColor = .lightGray
        return view
    }()
    
    let bottomSVBackground = OutlinedView(strokeWidth: .chuStrokeWidth)
    
    let bottomSV = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 15
        return sv
    }()
    
    let negativeSV = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 5
        return sv
    }()
    
    let negativeTitleLabel = {
        let label = UILabel()
        
        // 볼드체 설정
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.chuBlack ]
        
        // 텍스트 뒤에 이미지 붙이기
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "circle.fill")? // 옵셔널 체이닝임 놀라지 말 것
            .resizeImage(newWidth: 12)
            .withTintColor(.chuBadRate)
        
        // 텍스트 설정
        let attributedString = NSMutableAttributedString(string: String(localized: "부작용 "), attributes: attributes)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        label.attributedText = attributedString
        return label
    }()
    
    let negativeCV = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(LoggableCapsuleCell.self, forCellWithReuseIdentifier: LoggableCapsuleCell.identifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.clipsToBounds = true
        cv.layer.cornerRadius = 25
        cv.setSinglelineLayout(spacing: 5, width: 100, height: 50)
        return cv
    }()
    
    let negativeEmptyView = EmptyView(text: String(localized: "아직 등록된 부작용이 없는 것 같아요."), textSize: 14)
    
    let otherSV = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 5
        return sv
    }()
    
    let otherTitleLabel = {
        let label = UILabel()
        
        // 볼드체 설정
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.chuBlack ]
        
        // 텍스트 뒤에 이미지 붙이기
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "circle.fill")? // 옵셔널 체이닝임 놀라지 말 것
            .resizeImage(newWidth: 12)
            .withTintColor(.chuOtherRate)
        
        // 텍스트 설정
        let attributedString = NSMutableAttributedString(string: String(localized: "기타 증상 "), attributes: attributes)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        label.attributedText = attributedString
        return label
    }()
    
    let otherCV = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(LoggableCapsuleCell.self, forCellWithReuseIdentifier: LoggableCapsuleCell.identifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.clipsToBounds = true
        cv.layer.cornerRadius = 25
        cv.setSinglelineLayout(spacing: 5, width: 100, height: 50)
        return cv
    }()
    
    let otherEmptyView = EmptyView(text: String(localized: "아직 등록된 증상이 없는 것 같아요."), textSize: 14)

    let confirmButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = String(localized: "추가")
        config.baseBackgroundColor = .chuBlack
        config.baseForegroundColor = .chuWhite
        let button =  UIButton(configuration: config)
        button.isEnabled = false
        return button
    }()
    

    
    //MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .chuIvory
        
        setAutoLayout()
        setBinding()
    }
    
    //MARK: - 오토레이아웃
    func setAutoLayout() {
        view.addSubview(pendingLogTV)
        view.addSubview(titleBackground)
        view.addSubview(bottomSVBackground)
        titleBackground.addSubview(titleLabel)
        titleBackground.addSubview(closeButton)
        bottomSVBackground.addSubview(bottomSV)
        bottomSV.addArrangedSubview(negativeSV)
        bottomSV.addArrangedSubview(otherSV)
        bottomSV.addArrangedSubview(confirmButton)

        negativeSV.addArrangedSubview(negativeTitleLabel)
        negativeSV.addArrangedSubview(negativeCV)
        
        otherSV.addArrangedSubview(otherTitleLabel)
        otherSV.addArrangedSubview(otherCV)

        pendingLogTV.snp.makeConstraints { make in
            make.top.equalTo(titleBackground.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomSVBackground.snp.top)
        }
        titleBackground.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: .chuSpace, bottom: 10, right: .chuSpace))
        }
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        bottomSVBackground.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview() // 배경은 세이프 에어리어 밑까지 채워야 함
        }
        bottomSV.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15) // 스택뷰는 세이프 에어리어까지만
        }
        negativeCV.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        otherCV.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    //MARK: - 바인딩
    func setBinding() {
        // input
        confirmButton
            .rx.tap
            .bind(to: addLogVM.input.tappedConfirmButton)
            .disposed(by: bag)
        
        closeButton
            .rx.tap
            .bind(to: addLogVM.input.tappedCloseButton)
            .disposed(by: bag)
        
        
        // output
        addLogVM.output.negativeData
            .bind(to: negativeCV.rx.items(cellIdentifier: LoggableCapsuleCell.identifier, cellType: LoggableCapsuleCell.self)){ index, item, cell in
                cell.setAttributes(item: item)
                cell.addTask = { [weak self] in self?.addLogVM.input.addPendingLog.onNext(.init(name: item.name, hex: item.hex, isNegative: item.isNegative, rate: 3)) } // input
            }
            .disposed(by: bag)
        
        
        addLogVM.output.otherData
            .bind(to: otherCV.rx.items(cellIdentifier: LoggableCapsuleCell.identifier, cellType: LoggableCapsuleCell.self)){ index, item, cell in
                cell.setAttributes(item: item)
                cell.addTask = { [weak self] in self?.addLogVM.input.addPendingLog.onNext(.init(name: item.name, hex: item.hex, isNegative: item.isNegative, rate: 3)) } // input
            }
            .disposed(by: bag)
        
        
        // 증상 테이블에 아직 등록된 증상이 없다면 표시
        addLogVM.output.isSymptomDataEmpty
            .bind(onNext: { [weak self] in
                if $0 {
                    self?.negativeCV.backgroundView = self?.negativeEmptyView
                }else{
                    self?.negativeCV.backgroundView = .none
                }
                
                if $1 {
                    self?.otherCV.backgroundView = self?.otherEmptyView
                }else{
                    self?.otherCV.backgroundView = .none
                }
            })
            .disposed(by: bag)
        
        
        addLogVM.output.pendingLogData
            .bind(to: pendingLogTV.rx.items(cellIdentifier: PendingLogCell.identifier, cellType: PendingLogCell.self)){ [weak self] index, item, cell in
                guard let self else { return }
                cell.setAtrributes(item: item)
                cell.removeCellTask = { self.addLogVM.input.removePendingLogByIndex.onNext(index) } // input
                cell.sliderValueChangedTask = { self.addLogVM.input.updateRate.onNext( (index: index, rate: Int(cell.slider.value)) ) } // input
            }
            .disposed(by: bag)
        
        
        // 테이블에 아무것도 없을 때 추가버튼 비활성화
        addLogVM.output.isEnabledConfirmButton
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: bag)
        
        
        // 테이블에 뭐라도 있다면 모달 제스처로 닫기 비활성화
        addLogVM.output.isEnabledModalGesture
            .bind(onNext: { [weak self] in self?.isModalInPresentation = $0 })
            .disposed(by: bag)
        
        
        // 추가된 임시 기록이 없으면 안내문구 표시
        addLogVM.output.isPendingLogEmpty
            .bind(onNext: { [weak self] in
                if $0 {
                    self?.pendingLogTV.backgroundView = self?.pendingLogEmptyView
                }else{
                    self?.pendingLogTV.backgroundView = .none
                }
            })
            .disposed(by: bag)
        
        
        addLogVM.output.confirmWithDismiss
            .bind(onNext: { [weak self] in
                self?.addLogVM.input.saveByLogData.onNext(()) // input, 리스트 저장 이벤트 전송
                self?.dismissTask?()
                self?.dismiss(animated: true)
            })
            .disposed(by: bag)
        
        
        addLogVM.output.justDismiss
            .bind(onNext: { [weak self] in self?.dismiss(animated: true) })
            .disposed(by: bag)
    }

}



#Preview(traits: .fixedLayout(width: 400, height: 400)) {
    AddLogVC()
}
