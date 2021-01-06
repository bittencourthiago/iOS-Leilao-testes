//
//  EncerradorDeLeilaoTests.swift
//  LeilaoTests
//
//  Created by Thiago Bittencourt Coelho on 06/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class EncerradorDeLeilaoTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    
    func testDeveEncerrarLeiloesQueComecaramUmaSemanaAntes() {
        let formatador = DateFormatter()
        
        formatador.dateFormat = "yyyy/MM/dd"
        
        guard let dataAntiga = formatador.date(from: "2018/05/09") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV LED").naData(data: dataAntiga).constroi()
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        
        let dao = MockLeilaoDao()
        
        
        
        let encerradorDeLeilao = EncerradorDeLeilao(dao)
        encerradorDeLeilao.encerra()
        
        let leiloesEncerrados = dao.encerrados()
        
        XCTAssertEqual(2, leiloesEncerrados.count)
        XCTAssertTrue(leiloesEncerrados[0].isEncerrado()!)
        XCTAssertTrue(leiloesEncerrados[1].isEncerrado()!)
    }
    

}
