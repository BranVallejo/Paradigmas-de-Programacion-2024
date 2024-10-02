class Persona {
  var temperatura = 36
  var cantidadDeCelulas = 0
  var enfermedades = []

  method cantidadDeCelulas() = cantidadDeCelulas

  method destruirCelulas(celulasDestruidas) {
  cantidadDeCelulas = cantidadDeCelulas - celulasDestruidas
  }

  method aumentarTemperatura(aumento) {
    if (temperatura + aumento > 45) {
      temperatura = 45
    } else {
      temperatura = temperatura + aumento
    }
  }

  method contraerEnfermedad(enfermedad) {
    enfermedades.add(enfermedad)
  }

  method pasarUnDia() {
    enfermedades.forEach({ enfermedad => enfermedad.producirEfecto(self) })
  }



  method estaEnComa(){

  }
}

class Enfermedad {
  var celulasAmenazadas = 0
  var tipo = infecciosas // Creo que está mal que el default sea este, no sé si se puede poner un NULL o algo así
  var diasAfectando = 0

  method celulasAmenazadas() = celulasAmenazadas
  
  method esAgresiva(persona) {
    tipo.esAgresiva(persona, celulasAmenazadas, diasAfectando)
  }

  method producirEfecto(persona) {
    tipo.hacerEfecto(persona, celulasAmenazadas)
    diasAfectando = diasAfectando + 1
  }
}

object infecciosas {
  method hacerEfecto(persona, celulasAmenazadas) {
    persona.aumentarTemperatura(celulasAmenazadas/1000)
  }
  method reproducirse() {

  }

  method esAgresiva(persona, celulasAmenazadas, diasAfectando) {
    persona.cantidadDeCelulas() * 0.1 < celulasAmenazadas
  }

}

object autoinmunes {
  method hacerEfecto(persona, celulasAmenazadas) {
    persona.destruirCelulas(celulasAmenazadas)
  }

  method esAgresiva(persona, celulasAmenazadas, diasAfectando){
    diasAfectando > 30
  }
}