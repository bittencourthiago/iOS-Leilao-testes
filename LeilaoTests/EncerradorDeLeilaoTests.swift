//
//  EncerradorDeLeilaoTests.swift
//  LeilaoTests
//
//  Created by Thiago Bittencourt Coelho on 06/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

class EncerradorDeLeilaoTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    
    func testDeveEncerrarLeiloesQueComecaramUmaSemanaAntes() {
        let formatador = DateFormatter()
        
        formatador.dateFormat = "yyyy/MM/dd"
        
        guard let dataAntiga = formatador.date(from: "2020/12/29") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV LED").naData(data: dataAntiga).constroi()
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        
        let leiloesAntigos = [tvLed, geladeira]
        
        //withEnabledSuperclassSpy faz com que o mock da classe chame os metodos originais caso o mock não seja ensinado
        let daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()
        
        //ensinando o mock
        stub(daoFalso) { (daoFalso) in
            when(daoFalso.correntes()).thenReturn(leiloesAntigos)
        }
        
        let encerradorDeLeilao = EncerradorDeLeilao(daoFalso)
        encerradorDeLeilao.encerra()
        
        let leiloesEncerrados = daoFalso.encerrados()
        
        guard let statusTvLed = tvLed.isEncerrado() else { return }
        guard let statusGeladeira = geladeira.isEncerrado() else { return }
        
        XCTAssertEqual(2, encerradorDeLeilao.getTotalEncerrados())
        XCTAssertTrue(statusTvLed)
        XCTAssertTrue(statusGeladeira)
    }
    

}
