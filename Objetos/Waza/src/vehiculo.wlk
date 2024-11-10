import usuario.*
import zona.*
import app.*

class Vehiculo {
  const capacidadDeTanque
  var property cantidadDeCombustible
  const velocidadPromedio

  method cargarTanque(unosLitros) {
    cantidadDeCombustible = capacidadDeTanque.min(cantidadDeCombustible + unosLitros)
  }

  method recorrer(unosKilometros) {
    self.perderCombustible( self.consumoBase() + self.consumoAdicional(unosKilometros))
  }
  
  method perderCombustible(unaCantidad) {
    cantidadDeCombustible -= unaCantidad
  }

  method consumoBase() = 2
  method consumoAdicional(unosKilometros)
  method esEcologico()

  method velocidadPromedio() = velocidadPromedio
  method esMasRapidoQue(unaVelocidad) = velocidadPromedio > unaVelocidad
}

class Camioneta inherits Vehiculo {
  override method consumoBase() = 4
  override method consumoAdicional(unosKilometros) = 5 * unosKilometros
  override method esEcologico() = false
}

class Deportivo inherits Vehiculo {
  override method consumoAdicional(unosKilometros) = 0.2 * self.velocidadPromedio()
  override method esEcologico() = self.velocidadPromedio() < 120
}

class Familiar inherits Vehiculo {
  override method consumoAdicional(unosKilometros) = 0
  override method esEcologico() = true
}
