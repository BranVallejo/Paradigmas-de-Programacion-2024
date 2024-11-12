import barco.*

class Mision {
    method elPirataEsUtil(unPirata) 

    method puedeHacerlaElBarco(unBarco) = unBarco.suficienteTripulacion() && self.requisitoBarco(unBarco)

    method requisitoBarco(unBarco)
}

object busquedaDelTesoro inherits Mision {
  override method elPirataEsUtil(unPirata) = unPirata.noTieneMasDe5Monedas() && self.tieneItemsNecesarios(unPirata) 

  method tieneItemsNecesarios(unPirata) = unPirata.tiene("brujula") && unPirata.tiene("mapa") || unPirata.tiene("botella de grogXD") 

  override method requisitoBarco(unBarco) = unBarco.alguienTiene("llave de cofre") 
}

class ConvertirseEnLeyenda inherits Mision {
  const itemNecesario

  override method elPirataEsUtil(unPirata) = unPirata.tiene(itemNecesario) && unPirata.itemsMinimos(10)

  override method requisitoBarco(unBarco) = true
}

class Saqueo inherits Mision {
    const objetivo
    var monedasLimite
    method monedasLimite(nuevoLimiteDeMonedas) {
      monedasLimite = nuevoLimiteDeMonedas
    }

    override method elPirataEsUtil(unPirata) = unPirata.tieneMenosDineroQue(monedasLimite) && objetivo.seAnima(unPirata)

    override method requisitoBarco(unBarco) = objetivo.esVulnerableA(unBarco)
}



class CiudadCostera {
    const habitantes = []
    method nuevoHabitante(nuevoHabitante) {
        habitantes.add(nuevoHabitante)
    }
    method cantidadDeHabitantes() = habitantes.size()

    method seAnima(unPirata) = unPirata.nivelDeEbriedadMinimo(50)

    method esVulnerableA(unBarco) = unBarco.todosPasadosDeGrogXD() || unBarco.tieneAlMenos(self.cantidadDeHabitantes() * 0.4)
}

/*
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