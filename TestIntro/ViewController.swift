//
//  ViewController.swift
//  TestIntro
//
//  Created by dev717 on 02.11.2020.
//

import UIKit

protocol TableScrollDelegate: class {
    func scrollTableFromIntro(indexPath: IndexPath)
}

class ViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    let arrayIntro: [(String, IndexPath)] = [
        ("Здесь вы можете настроить отклонение от среднерыночной цены в регионе объявления. Отрицательные значения показывают автомобили ниже рынка, положительные выше рынка. Задавать можно как в процентах или рублях.",
         IndexPath(row: 0, section: 3)),
        ("Регины поиска объявлений. Если не выбран ни один регион, то поиск по всей стране. После выбора регионов можно выбрать конкретные населенные пункты.",
         IndexPath(row: 0, section: 13)),
        ("Для указания радиуса нужно выбрать один населенный пункт, от которого идёт поиск.",
         IndexPath(row: 2, section: 13)),
        ("В фильтре есть возможность настроить поиск только по первой публикации объявлений, либо по снижению цены. Можно выбрать два типа выдачи объявлений одновременно.", IndexPath(row: 0, section: 14)),
        ("На классифайдах есть различные плашки (хорошая цена, продаёт собственник и т.д). Мы фиксируем некоторые из этих тегов и даём пользователям возможность осуществлять по ним поиск.",
         IndexPath(row: 1, section: 14)),
        ("Сайты, где размещены объявления. Если не выбран ни один, то поиск ведется по всем сразу.",
         IndexPath(row: 0, section: 15)),
        ("Вы можете настроить оповещение в Телеграм боте по настраиваемым фильтрам. Будут приходить объявления по фильтрам, где активирована кнопка Телеграм. Привязать свой Телеграм можно по инструкции из личного кабинета на сайте, либо в самом боте в Телеграм.",
         IndexPath(row: 1, section: 16)),
        ("Аналогичная история, как с Телеграмом, только на почту. Адрес можно указать в личном кабинете. Объявления часто могут попадать в спам, либо приходить с задержкой, это зависит от вашего почтового клиента. Не рекомендуем данный способ уведомления, лучше Телеграм или Push уведомления.",
         IndexPath(row: 2, section: 16))
    ]
    
    weak var delegate: ShowIntroDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(showIntro))
    }
}

//MARK: -Other func
extension ViewController {
    @objc
    fileprivate
    func showIntro() {
        tableView.scrollToRow(at: self.arrayIntro.first!.1, at: .middle, animated: true)
        
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when, execute: { () -> Void in            
            let rectOfCell = self.tableView.rectForRow(at: self.arrayIntro.first!.1)
            let rectOfCellInSuperview = self.tableView.convert(rectOfCell, to: self.tableView.superview)
            
            let introFiltrViewController = IntroFiltrViewController(arrayIntro: self.arrayIntro, yPosition: rectOfCellInSuperview.origin.y + rectOfCellInSuperview.size.height, delegate: self)
            self.delegate = introFiltrViewController
            introFiltrViewController.modalTransitionStyle = .crossDissolve
            introFiltrViewController.modalPresentationStyle = .overCurrentContext
            self.present(introFiltrViewController, animated: true, completion: nil)
        })
    }
}

extension ViewController: TableScrollDelegate {
    func scrollTableFromIntro(indexPath: IndexPath) {
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when, execute: { () -> Void in
            let rectOfCell = self.tableView.rectForRow(at: indexPath)
            let rectOfCellInSuperview = self.tableView.convert(rectOfCell, to: self.tableView.superview)

            self.delegate?.changeIntro(yPosition: rectOfCellInSuperview.origin.y)
        })
    }
}
