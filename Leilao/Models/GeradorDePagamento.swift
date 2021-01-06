//
//  GeradorDePagamento.swift
//  Leilao
//
//  Created by Thiago Bittencourt Coelho on 06/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import Foundation

class GeradorDePagamento {
    
    private var leiloes:LeilaoDao
    private var avaliador:Avaliador
    private var repositorioDePagamento:RepositorioDePagamento
    
    init(_ leiloes:LeilaoDao, _ avaliador:Avaliador, _ repositorioDePagamento:RepositorioDePagamento) {
        self.leiloes = leiloes
        self.avaliador = avaliador
        self.repositorioDePagamento = repositorioDePagamento
    }
    func gera() {
        
        let leiloesEncerrados = self.leiloes.encerrados()
        
        for leilao in leiloesEncerrados {
            try? avaliador.avalia(leilao: leilao)
            
            let novoPagamento = Pagamento(avaliador.maiorLance(), Date())
            
            RepositorioDePagamento.salva(novoPagamento)
        }
        
    }
    
}
