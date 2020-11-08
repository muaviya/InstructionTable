//
//  IntroFiltrViewController.swift
//  TestIntro
//
//  Created by dev717 on 05.11.2020.
//

import UIKit

protocol ShowIntroDelegate: class {
    func changeIntro(yPosition: CGFloat)
}

class IntroFiltrViewController: UIViewController {
    //MARK: -Outlets
    @IBOutlet weak var upTriangle: UIView!
    @IBOutlet weak var downTriangle: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton! {
        didSet {
            closeBtn.layer.cornerRadius = 45/2
        }
    }
    
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

        titleLbl.text = arrayIntro.first!.0
        
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant:70).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.drawTriangle(up: true, triangleLayer: triangleLayerUp)
    }
}

//MARK: -Other func
extension IntroFiltrViewController {
}

//MARK: -Actions
extension IntroFiltrViewController {
    @IBAction func closeView() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func tapViewGesture(_ sender: Any) {
        index += 1
        if arrayIntro.indices.contains(index) {
            delegate?.scrollTableFromIntro(indexPath: arrayIntro[index].1)
        }
    }
}

//MARK: -Triangle
extension IntroFiltrViewController {
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

extension IntroFiltrViewController: ShowIntroDelegate {
    func changeIntro(yPosition: CGFloat) {
        titleLbl.text = arrayIntro[index].0
        self.mainView.translatesAutoresizingMaskIntoConstraints = false

        if index > 5 {
            
            triangleLayerDown.removeFromSuperlayer()
            triangleLayerUp.removeFromSuperlayer()
            
            var resultPosition = yPosition - 255
            if index > 6 {
                resultPosition = yPosition - 275
            }

            mainView.topAnchor.constraint(equalTo: self.view.topAnchor, constant:resultPosition).isActive = true

            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when, execute: { () -> Void in
                self.drawTriangle(up: false, triangleLayer: self.triangleLayerDown)
            })
        } else {
            let resultPosition = yPosition + 200
            mainView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant:resultPosition).isActive = true
        }
        self.view.layoutIfNeeded()
    }
}



