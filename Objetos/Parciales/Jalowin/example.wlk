/*
Duda:
  ¿Cómo limitar la actitud del 1 al 10?
  Opción 1:
    hago un armador de ninios, como en el de las legiones, y le pongo que si 1 <= actitud <= 10
    tire un DomainException
  Opción 2:
    method actitud() = actitud.max(10).min(1) , hago eso y cada vez que me piden actitud lo reemplazo por eso
    Igual esta opción me parece una crotada
*/
//Ejempĺos para testear
const pablo = new Ninio(actitud = 10, elementosPuestos = [lobo])
const pinturaRoja  = new Maquillaje()
const lobo  = new Traje(tipo = terrorifico)
const ema = new Ninio(actitud = 10, elementosPuestos = [lobo, pinturaRoja], caramelos = 30)
const jazmin = new AdultoComun()

//                                    Ninios (Niños)
class Ninio {
  const actitud
  var elementosPuestos = []
  var property caramelos = 0
  var property salud = sano

  method actitud() = actitud * salud.modificadorDeActitud()

  method puedeAsustar() = salud.puedoSalirAAsustar()

  method capacidadDeAsustar() {
    const sumatoriaDeElementos = elementosPuestos.sum ({elemento => elemento.susto()})
    return sumatoriaDeElementos * actitud
  }

  method asustar(unAdulto){
    if (self.puedeAsustar()) {
      unAdulto.asustarse(self)
    } else {
      throw new DomainException (message = "Un niño en cama no puede Asustar.")
    }

  }

  method ganarCaramelos(unaCantidad){
    caramelos += unaCantidad
  } 
  
  // PARTE D: Alimentación & PARTE E: Indigestión (leer a lo último)
  method comerCaramelos(unaCantidad) {
    self.puedoComer(unaCantidad)
    self.afectar(unaCantidad)
  }

  // ¿Debería separarlos uno por cantidad y otro por salud??
  method puedoComer(unaCantidad) { //Si no puede comer tira un exception
    if( self.caramelos() < unaCantidad || !salud.puedoComerCaramelos()) {
      throw new DomainException (message = "No podés comer caramelos.")
    }
  }

  method afectar(unaCantidad) {
    caramelos -= unaCantidad
    if (unaCantidad >= 10) {
      salud.empeorar(self)
    }
  }
}


//                                        Elementos
class Elemento {
  method susto()
}

class Maquillaje inherits Elemento {
  var property nivelDeAsustar = 3
  
  override method susto() = nivelDeAsustar
}

// deberían ser class los tipos de traje?
class Traje inherits Elemento {
  
  const tipo
  
  override method susto() = tipo.cuantoAsusta()
}

object tierno {
  method cuantoAsusta() = 2
}

object terrorifico {
  method cuantoAsusta() = 5
}

//                                               Adultos

class Adulto {
  method puedeAsustarse(unNinio)

  method asustarse(unNinio) {
    if (self.puedeAsustarse(unNinio)) {
      self.darCaramelos(unNinio)

    }
  }

  method darCaramelos(unNinio)

  method caramelosADar()
}

class AdultoComun inherits Adulto {
  var niniosQueLoAsustaron = 0

  method tolerancia() = 10 * niniosQueLoAsustaron 
  // ¿Por qué si hago var tolerancia = 10 * niniosQueLoAsustaron se queda clavado en 0 y no se mueve?
  
  override method puedeAsustarse(unNinio) =  self.tolerancia() < unNinio.capacidadDeAsustar()

  override method caramelosADar() = self.tolerancia() / 2

  override method darCaramelos(unNinio){
    unNinio.ganarCaramelos(self.caramelosADar())
    self.aumentoSustos(unNinio)
  }

  method aumentoSustos(unNinio) {
    if(unNinio.caramelos() > 15){
      niniosQueLoAsustaron = niniosQueLoAsustaron + 1 // si hago niniosQueLoAsustaron++ me rompe :o
    }
  }
}

class Abuelo inherits AdultoComun {
  override method puedeAsustarse(unNinio) = true

  override method caramelosADar() = super() / 2
}

class Necio inherits Adulto{
  override method puedeAsustarse(unNinio) = false

  override method caramelosADar() = 0
}


//                                           PARTE B: Legiones

class Legion {
  var miembros = []

  method capacidadDeAsustar() = miembros.sum({ ninio => ninio.capacidadDeAsustar() })
  method caramelos() = miembros.sum({ ninio => ninio.caramelos() })
  method lider() = miembros.max( { ninio => ninio.capacidadDeAsustar() })
  
  //todo lo que requiere asustarse es polimorfico con la legión (capacidadDeAsustar es necesario en Adulto Comun y acá lo puede hacer también)

  method asustar(unAdulto) {
    unAdulto.asustarse(self)
  }

  method ganarCaramelos(unaCantidad){
    self.lider().ganarCaramelos(unaCantidad)
  } 

}

// ejemplo de uso: const legionGrande = armarLegion.nuevaLegion([pablo, ema])
object armarLegion {
  method nuevaLegion(unosNinios) {
    if (unosNinios.size() >= 2) {
      return new Legion(miembros = unosNinios)
    } else  {
      throw new DomainException(message = "Son necesarios como mínimo 2 miembros") 
    }
  }  
}

class SupraLegion inherits Legion {
  
  // Puede hacer todo lo que hace una legión ya que es polimorfico, pero tuve que modificar
  // el ganarCaramelos para que funcione cuando el que reciba sea una persona y una legión.
  override method ganarCaramelos(unaCantidad) {
    miembros.forEach({miembro => miembro.ganarCaramelos(unaCantidad)})
  }   
}

//                                       PARTE C: Estadísticas Barriales

// tengo una consulta, despues lo hago, sobre el punto 2
// Cómo elimino repetidos? Lo hago un set? Hay otra forma?

//                                       PARTE D: Alimentación Está en el class Ninio

class TipoDeSalud {
  method modificadorDeActitud()
  method puedoComerCaramelos()
  method puedoSalirAAsustar()
}
object sano inherits TipoDeSalud{
  override method modificadorDeActitud() = 1
  override method puedoComerCaramelos() = true
  override method puedoSalirAAsustar() = true
  method empeorar(unNinio) {
    unNinio.salud(empachado) // Estoy rompiendo el encapsulamiento acá???
  }
}

object empachado inherits TipoDeSalud{
  override method modificadorDeActitud() = 0.5
  override method puedoComerCaramelos() = true
  override method puedoSalirAAsustar() = true
  method empeorar(unNinio) {
    unNinio.salud(enCama) // Estoy rompiendo el encapsulamiento acá???
  }
}

object enCama inherits TipoDeSalud{
  override method modificadorDeActitud() = 0
  override method puedoComerCaramelos() = false
  override method puedoSalirAAsustar() = false
  // A este no le agrego empeorar porque si está en cama directamente no va a llegar a empeorar
  // porque va a fallar cuando quiera intentar comer
}
