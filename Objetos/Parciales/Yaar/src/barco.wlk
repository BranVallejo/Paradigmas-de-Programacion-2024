import mision.*

class Barco {
  var mision
  const tripulacion = []
  const capacidad

  // 2)a)
  method puedeFormarParte(unPirata) = self.hayEspacio() && unPirata.esUtilParaUnaMision(mision)

  // 2)c)
  method cambiarMision(unaMision) {
    mision = unaMision
    tripulacion.filter({
      pirata => pirata.esUtilParaUnaMision(unaMision)
    })
  }
  
  // 3)a)
  method elMasEbrio() = tripulacion.max({ pirata => pirata.nivelDeEbriedad() })

  // 3)b)
  method anclarEnCiudadCostera(unaCiudad) {
    self.todosTomanUnTrago()
    self.expulsarDeLaTripulacion(self.elMasEbrio())
    unaCiudad.nuevoHabitante(self.elMasEbrio())
  }

  method todosTomanUnTrago() {
    tripulacion.forEach({ pirata => pirata.tomarUnTrago()})
  }
  
  // 4)a)
  method esTemible() = mision.puedeHacerlaElBarco(self)

  method alguienTiene(unObjeto) = tripulacion.any({ 
    pirata => pirata.tiene(unObjeto)
  })

  method seAnima(unPirata) = unPirata.estaPasadoDeGrogXD()

  method todosPasadosDeGrogXD() = tripulacion.all({
    tripulante => tripulante.estaPasadoDeGrogXD()
  })

  method tieneAlMenos(unaCantidadDeTripulantes) = self.cantidadDePiratas() >= unaCantidadDeTripulantes

  method esVulnerableA(otroBarco) = otroBarco.tieneAlMenos(self.cantidadDePiratas() * 0.5)


  method suficienteTripulacion() = self.cantidadDePiratas() > capacidad * 0.9
  method cantidadDePiratas() = tripulacion.size()
  method hayEspacio() = self.cantidadDePiratas() < capacidad
  method expulsarDeLaTripulacion(unPirata) {
    tripulacion.remove(unPirata)
  }
  
}

class Pirata {
  const items = #{}
  var nivelDeEbriedad
  var dinero

  method esUtilParaUnaMision(unaMision) = unaMision.elPirataEsUtil(self)

  method tomarUnTrago() {
    self.subirEbriedad(5)
    self.gastarDinero(1)
  }
  method gastarDinero(unaCantidad) {
    dinero -= unaCantidad
  }


  method itemsMinimos(unaCantidad) = self.cantidadDeItems() >= 10
  method cantidadDeItems() = items.size()
  method tiene(unItem) = items.contains(unItem)
  method tieneMenosDineroQue(unaCantidad) = self.dinero() < unaCantidad
  method noTieneMasDe5Monedas() = self.dinero() <= 5
  method dinero() = dinero
  method nivelDeEbriedadMinimo(unaCantidad) = nivelDeEbriedad >= unaCantidad
  method estaPasadoDeGrogXD() = self.nivelDeEbriedadMinimo(90)
  method nivelDeEbriedad() = nivelDeEbriedad
  method subirEbriedad(unaCantidad) {
    nivelDeEbriedad += unaCantidad
  }
}
// 4) B)
class EspiaDeLaCorona inherits Pirata {
  override method estaPasadoDeGrogXD() = false
}
/*
TODO: En ciudad.subirUnHabitante
  Barco
  Mision; tripulacion [pirata]; capacidad
  cambiarMision() -> tambien Expulsa piratas
  esTemible()
  tieneSuficienteTripulacion()

  Pirata
  items; nivelDeEbrieldad; dinero;

  Misiones
  elPirataEsUtil(unPirata)
  puedeHacerlaElBarco(unPirata)
*/
// DUDA: ¿El 2)B) lo tendría que hacer en los tests?