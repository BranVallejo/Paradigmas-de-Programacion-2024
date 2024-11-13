import nave.*
import tareas.*

class Jugador {
  const color
  var nivelDeSospecha
  const mochila = []
  const tareas = []
  var puedeVotar = true
  var estaVivo = true

  method esSospechoso() = nivelDeSospecha > 50

  method buscarItem(unItem) = mochila.add(unItem)

  method votoImpugnado() {
    puedeVotar = false
  }

  method llamarReunionDeEmergencia() {
    nave.reunionDeEmergencia()
  }

  method aumentarNivelDeSospecha(unaCantidad) {
    nivelDeSospecha += unaCantidad
  }
  method disminuirNivelDeSospecha(unaCantidad) {
    nivelDeSospecha -= unaCantidad
  }
  method tiene(unItem) = mochila.contains(unItem)
  method usarItem(unItem) = mochila.remove(unItem)  
  method noTieneNada() = mochila.isEmpty()
  method nivelDeSospecha() = nivelDeSospecha
  method estaVivo() = estaVivo
}

class Tripulante inherits Jugador {
  const personalidad

  method completoSusTareas() = tareas.isEmpty()

  method hacerCualquierTarea() {
    const tarea = self.tareaPendienteQueSePuedeHacer()
    tarea.recompensa(self)
    self.removerItemsUsados(tarea.itemsNecesarios())
    tareas.remove(tarea)
    nave.tareaTerminada()
  }
  
  method tareaPendienteQueSePuedeHacer() = tareas.find({tarea => tarea.tieneLosItemsNecesarios(self)})

  method removerItemsUsados(unosItems) {
    unosItems.forEach({unItem => self.usarItem(unItem)})
  }

  method votar() = personalidad.votarA()

  method expulsar() {
    estaVivo = false
    puedeVotar = false
    nave.expulsarTripulante()
  }
}
object troll {
  method votarA() = nave.alguienNoSospechoso()
}

object detective {
  method votarA() = nave.mayorSospechoso()
}
object materialista {
  method votarA() = nave.alguienConMochilaVacia()
}

class Impostor inherits Jugador {
  
  method completoSusTareas() = true

  method hacerTarea() {
    // No hace nada
  }

  method hacerSabotaje(unSabotaje) {
    self.aumentarNivelDeSospecha(5)
    unSabotaje.afectar()
  } 

  method votar() = nave.jugadorRandom()


  method expulsar() {
    estaVivo = false
    puedeVotar = false
    nave.expulsarImpostor()
  }
}
/*
  nave wko
  jugadores [], int tripulantesRestantes, int impostoresRestantes
  verificar si ganaron

  class jugadores
  color, mochila [], sospecha = 40, tareas = []
  hacerTarea -> eliminoItem, informo a la nave

  Tareas
  
*/