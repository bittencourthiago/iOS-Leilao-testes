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
    
    var formatador:DateFormatter!
    var encerradorDeLeilao:EncerradorDeLeilao!
    var daoFalso:MockLeilaoDao!
    var carteiroFalso:MockCarteiro!
    
    override func setUp() {
        
        
        formatador = DateFormatter()
        formatador.dateFormat = "yyyy/MM/dd"
        
        daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()
        
        carteiroFalso = MockCarteiro().withEnabledSuperclassSpy()
        
        encerradorDeLeilao = EncerradorDeLeilao(daoFalso, carteiroFalso)
    }

    override func tearDown() {
    }

    
    func testDeveEncerrarLeiloesQueComecaramUmaSemanaAntes() {

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
        
        encerradorDeLeilao.encerra()
        
        guard let statusTvLed = tvLed.isEncerrado() else { return }
        guard let statusGeladeira = geladeira.isEncerrado() else { return }
        
        XCTAssertEqual(2, encerradorDeLeilao.getTotalEncerrados())
        XCTAssertTrue(statusTvLed)
        XCTAssertTrue(statusGeladeira)
    }
    func testDeveAtualizarLeiloesEncerrados() {
        
        guard let dataAntiga = formatador.date(from: "2020/12/29") else { return }
    
        let tvLed = CriadorDeLeilao().para(descricao: "TV LED").naData(data: dataAntiga).constroi()
        
        
        stub(daoFalso) { (daoFalso) in
            
            //quando(daoFalso).correntes() for chamado retorna ([tvLed])
            when(daoFalso).correntes().thenReturn([tvLed])
        }
        
        encerradorDeLeilao.encerra()
        
        //verifica se o metodo atualiza esta sendo chamado
        verify(daoFalso).atualiza(leilao: tvLed)
        
    }
    
    func testDeveContinuarAExecucaoMesmoQuandoDaoFalha() {
        guard let dataAntiga = formatador.date(from: "2020/12/29") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV LED").naData(data: dataAntiga).constroi()
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        
        
        stub(daoFalso) { (daoFalso) in
            when(daoFalso).correntes().thenReturn([tvLed, geladeira])
            when(daoFalso.atualiza(leilao: tvLed)).thenThrow(error)
        }
        encerradorDeLeilao.encerra()
        
        verify(daoFalso).atualiza(leilao: geladeira)
        verify(carteiroFalso).envia(geladeira)
        
    }
    
}

extension Leilao:Matchable {
    public var matcher:ParameterMatcher<Leilao> {
        return equal(to: self)
    }
}
