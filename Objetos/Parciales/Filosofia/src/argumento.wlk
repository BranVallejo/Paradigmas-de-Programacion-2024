import filosofo.*
import actividad.*

class Argumento {
    const descripcion
    const naturaleza

    method esEnriquecedor() = naturaleza.enriquecedor(self)

    method esUnaPregunta() = descripcion.endsWith("?")

    method tieneUnTamanioMinimo(unTamanio) = descripcion.size() >= unTamanio

}

object estoico {
    method enriquecedor(unArgumento) = true
}

object moralista {
    method enriquecedor(unArgumento) = unArgumento.tieneUnTamanioMinimo(10)
}

object esceptica {
    method enriquecedor(unArgumento) = unArgumento.esUnaPregunta()
}

object cinica {
    method enriquecedor(unArgumento) =  0.randomUpTo(100).between(0, 30)
}

class Combinados {
    const naturalezas

    method enriquecedor(unArgumento) = naturalezas.all({ 
        naturaleza => naturaleza.enriquecedor(unArgumento)
    })
}
