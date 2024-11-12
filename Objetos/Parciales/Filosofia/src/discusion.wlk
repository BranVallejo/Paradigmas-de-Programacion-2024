import argumento.*
import filosofo.*
import actividad.*

class Discusion {
    const unPartido
    const otroPartido

    method buenaDiscusion() = unPartido.esBueno() && otroPartido.esBueno()
}

class Partido {
    const unFilosofo
    const unosArgumentos

    method mayoriaEnriquesedora() = self.cantidadDeArgumentosEnriquecedores()  >= self.cantidadDeArgumentos() / 2
    
    method cantidadDeArgumentos() = unosArgumentos.size()
    method cantidadDeArgumentosEnriquecedores() = unosArgumentos.filter({ argumento => argumento.esEnriquecedor()}).size()



    method esBueno() = unFilosofo.estaEnLoCorrecto() && unFilosofo.mayoriaEnriquesedora()
}