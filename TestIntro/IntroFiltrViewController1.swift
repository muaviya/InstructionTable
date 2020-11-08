//
//  IntroFiltrViewController1.swift
//  TestIntro
//
//  Created by dev717 on 08.11.2020.
//

import UIKit

class IntroFiltrViewController1: UIViewController {
    //MARK: -Outlets
    private var didSetupConstraints = false

    var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 45/2
        btn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return btn
    }()
    
    var upTriangle = UIView()
    var downTriangle = UIView()
    var titleLbl = UILabel() {
        didSet {
            titleLbl.isUserInteractionEnabled = true
            let gest = UITapGestureRecognizer(target: self, action: #selector(nextStep))
            titleLbl.addGestureRecognizer(gest)
        }
    }
    
    var mainView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        let gest = UITapGestureRecognizer(target: self, action: #selector(nextStep))
        view.addGestureRecognizer(gest)
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: -Variables
    weak var delegate: TableScrollDelegate?
    let arrayIntro: [(String, IndexPath)]
    let yPosition: NSLayoutYAxisAnchor
    var index = 0
    
    var triangleLayerUp = CAShapeLayer()
    var triangleLayerDown = CAShapeLayer()
    
    init(arrayIntro: [(String, IndexPath)], yPosition: NSLayoutYAxisAnchor , delegate: TableScrollDelegate?) {
        self.delegate = delegate
        self.arrayIntro = arrayIntro
        self.yPosition = yPosition
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isUserInteractionEnabled = true
        let gest = UITapGestureRecognizer(target: self, action: #selector(nextStep))
        self.view.addGestureRecognizer(gest)
        
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
                
        view.addSubview(mainView)
        view.addSubview(closeBtn)
        //view.addSubview(titleLbl)
        mainView.addSubview(titleLbl)
        
        view.addSubview(upTriangle)
        view.addSubview(downTriangle)
        
        titleLbl.numberOfLines = 0
        //titleLbl.backgroundColor = .white
        titleLbl.textAlignment = .center
        titleLbl.text = arrayIntro.first!.0
        
        upTriangle.backgroundColor = .clear
        downTriangle.backgroundColor = .clear
        
        mainView.backgroundColor = .white
                
        mainView.translatesAutoresizingMaskIntoConstraints = false
        downTriangle.translatesAutoresizingMaskIntoConstraints = false
        upTriangle.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.drawTriangle(up: true, triangleLayer: triangleLayerUp)
    }

    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            NSLayoutConstraint.activate([
                mainView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant:70),
                mainView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                mainView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8)
            ])
            
            NSLayoutConstraint.activate([
                titleLbl.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
                titleLbl.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
                titleLbl.leftAnchor.constraint(equalTo: mainView.leftAnchor),
                titleLbl.rightAnchor.constraint(equalTo: mainView.rightAnchor)
            ])
           
            NSLayoutConstraint.activate([
                upTriangle.bottomAnchor.constraint(equalTo: self.titleLbl.topAnchor),
                upTriangle.centerXAnchor.constraint(equalTo: self.titleLbl.centerXAnchor),
                upTriangle.widthAnchor.constraint(equalToConstant: 24),
                upTriangle.heightAnchor.constraint(equalToConstant: 12)
            ])
            
            NSLayoutConstraint.activate([
                downTriangle.topAnchor.constraint(equalTo: self.titleLbl.bottomAnchor),
                downTriangle.centerXAnchor.constraint(equalTo: self.titleLbl.centerXAnchor),
                downTriangle.widthAnchor.constraint(equalToConstant: 24),
                downTriangle.heightAnchor.constraint(equalToConstant: 12)
            ])
    
            NSLayoutConstraint.activate([
                closeBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
                closeBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
                closeBtn.heightAnchor.constraint(equalToConstant: 45),
                closeBtn.widthAnchor.constraint(equalToConstant: 45)
            ])
    
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}

//MARK: -Other func
extension IntroFiltrViewController1 {
    @objc
    fileprivate
    func nextStep() {
        tapViewGesture(UIButton())
    }
}

//MARK: -Actions
extension IntroFiltrViewController1 {
    @objc
    func closeView() {
        index = 0
        dismiss(animated: true, completion: nil)
    }
    
    func tapViewGesture(_ sender: Any) {
        index += 1
        
        if index >= arrayIntro.count {
            index = 0
            dismiss(animated: true, completion: nil)
        } else {
            if arrayIntro.indices.contains(index) {
                delegate?.scrollTableFromIntro(indexPath: arrayIntro[index].1)
            }
        }
    }
}

//MARK: -Triangle
extension IntroFiltrViewController1 {
    func drawTriangle(up:Bool, triangleLayer: CAShapeLayer) {
        
        triangleLayerDown.removeFromSuperlayer()
        triangleLayerUp.removeFromSuperlayer()
        
        let size: CGFloat = 12
        let trianglePath = UIBezierPath()
        trianglePath.move(to: .zero)
        trianglePath.addLine(to: CGPoint(x: -size, y: up ? size : -size))
        trianglePath.addLine(to: CGPoint(x: size, y: up ? size : -size))
        trianglePath.close()
        
        view.layer.addSublayer(triangleLayer)
        
        let x = up ? self.upTriangle.frame.midX : self.downTriangle.frame.midX
        let y = up ? self.upTriangle.frame.minY : self.mainView.frame.maxY + 12
        
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = UIColor.white.cgColor
        triangleLayer.anchorPoint = .zero
        triangleLayer.position = CGPoint(x: x, y: y)
        triangleLayer.name = "triangle"
    }
}

extension IntroFiltrViewController1: ShowIntroDelegate {
    func changeIntro(yPosition: CGFloat) {
        self.titleLbl.text = self.arrayIntro[self.index].0

        if index > 5 {
            triangleLayerDown.removeFromSuperlayer()
            triangleLayerUp.removeFromSuperlayer()
            
            self.mainView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.mainView.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant:yPosition)
            ])
            
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when, execute: { () -> Void in

                self.drawTriangle(up: false, triangleLayer: self.triangleLayerDown)
            })
            
        } else {
            mainView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant:yPosition).isActive = true
        }
        titleLbl.sizeToFit()
    }
}
