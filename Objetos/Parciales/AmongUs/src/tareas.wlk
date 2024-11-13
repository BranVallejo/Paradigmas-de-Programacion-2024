import jugadores.*
import nave.*

class Tarea {
    const itemsNecesarios = []

    method tieneLosItemsNecesarios(unJugador) = itemsNecesarios.all({
        unItem => unJugador.tiene(unItem)
    })

    method recompensa(unTripulante)
    method itemsNecesarios() = itemsNecesarios
}

object arreglarElTablero inherits Tarea (itemsNecesarios = ["llave inglesa"]){
    override method recompensa(unTripulante) {
        unTripulante.aumentarNivelDeSospecha(10)
    }
  
}

object sacarLaBasura inherits Tarea (itemsNecesarios = ["llave inglesa"]){
    override method recompensa(unTripulante) {
        unTripulante.disminuirNivelDeSospecha(4)
    }
  
}
object ventilarLaNave inherits Tarea (itemsNecesarios = ["llave inglesa"]){
    override method recompensa(unTripulante) {
        nave.aumentarOxigeno(5)
    }
  
}

class Sabotaje {
    method afectar()
}

object reducirElOxigeno inherits Sabotaje {
  override method afectar() {
    nave.intentarBajarOxigeno(10)
  }
}


class impugnarAUnJugador inherits Sabotaje {
  const jugadorAImpugnar

  override method afectar() {
    jugadorAImpugnar.votoImpugnado()
  }
}