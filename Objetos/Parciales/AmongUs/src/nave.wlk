import jugadores.*
import tareas.*

object nave {
    const jugadores = []
    var tripulantesRestantes = 0
    var impostoresRestantes = 0
    var oxigeno = 100


    method tareaTerminada() {
        if (self.tareasTerminadas()) {
            throw new DomainException( message = "Ganaron los tripulantes")
        }
    }

    method intentarBajarOxigeno(unaCantidad) {
        if (! self.alguienTieneUnTubo()) {
            self.disminuirOxigeno(unaCantidad)
        }
    }

    method alguienTieneUnTubo() = jugadores.any({ jugador => jugador.tiene("tubo de oxigeno")})

    method reunionDeEmergencia() {
        const votos = self.jugadoresVivos().map({ jugador => jugador.votar() })
        const elMasVotado = votos.max { alguien => votos.occurrencesOf(alguien) }
        elMasVotado.expulsar()

        self.validarGanaronImpostores()
        self.validarGanaronTripulantes()
    }
    
    method jugadorRandom() = self.jugadoresVivos().anyOne()
    method alguienNoSospechoso() = self.jugadoresVivos().findOrDefault({ jugador => !jugador.esSospechoso() }, votoEnBlanco)
    method mayorSospechoso() = self.jugadoresVivos().findOrDefault({ jugador => jugador.nivelDeSospecha() }, votoEnBlanco)
    method alguienConMochilaVacia() = self.jugadoresVivos().findOrDefault({ jugador => jugador.noTieneNada() }, votoEnBlanco)

    method expulsarImpostor() {
        impostoresRestantes -= 1
    }

    method expulsarTripulante() {
        tripulantesRestantes -= 1
    }

    method aumentarOxigeno(unaCantidad) {
      oxigeno += unaCantidad
    }
    method disminuirOxigeno(unaCantidad) {
        self.validarGanaronImpostores()
        oxigeno -= unaCantidad
    }
    method validarGanaronTripulantes() {
        if ( impostoresRestantes == 0 ) {
            throw new DomainException ( message = "Ganaron los tripulantes." )
        }
    }

    method validarGanaronImpostores() {
        if( oxigeno  <= 0 || impostoresRestantes == tripulantesRestantes) {
            throw new DomainException ( message = "Ganaron los impostores.")
        }
    }

    method tareasTerminadas() = jugadores.all({ jugador => jugador.completoSusTareas() })

    method jugadoresVivos() = jugadores.filter({ jugador => jugador.estaVivo() })

}

object votoEnBlanco {
  method expulsar() {
    // No hace nada
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