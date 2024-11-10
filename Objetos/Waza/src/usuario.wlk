import vehiculo.*
import zona.*
import app.*
 
// Duda: En este parcial había que hacer tests? Sabés como va a ser en el parcial? Tenemos que crearlos nosotros para demostrar que está bien o nos lo piden detalladamente en el enunciado?
class Usuario {
  const nombreDeUsuario
  const dni
  const vehiculo
  var dineroEnCuenta
  var multas = #{}

  method conducir(unosKilometros) {
    vehiculo.recorrer(unosKilometros)
  }

  method cargarCombustible(unosLitros) {
    self.pagarLaCarga(unosLitros)
    vehiculo.cargarTanque(unosLitros)
  }


  method pagarLaCarga(unosLitros) {
    self.puedePagarCarga(unosLitros)
    self.gastar(shell.precioFinal(unosLitros))    
  }  

  method puedePagarCarga(unosLitros) {
    if ( !self.puedePagar(shell.precioCombustible()) ){
      throw new DomainException ( message = "No tenés dinero suficiente.")
    }
  }


  //Multas

  method pagarLasMultas() {
    multas.forEach({ multa => self.pagarMulta(multa) })
  }

  method pagarMulta(unaMulta) {
    self.puedePagar(unaMulta.precioMulta())
    self.gastar(unaMulta.precioMulta())
    self.quitarMulta(unaMulta)

  }

  method puedePagarMulta(unaMulta) {
    if ( !self.puedePagar(unaMulta.precioMulta()) ){
      unaMulta.subirPrecio()
      throw new DomainException ( message = "No tenés dinero suficiente.") // DUDA: debería sacar esto? creo que interrumpe el flujo del programa
    }    
  }

  method recibirMulta(unaMulta) {
    multas.add(unaMulta)
  }

  method quitarMulta(unaMulta) {
    unaMulta.fuePagada()
    multas.remove(unaMulta)
  }  

  method dniPar() = dni.even()
  method dniImpar() = dni.odd()

  // Controles

  method pasadoDeVelocidad(unaVelocidadMaxima) = vehiculo.esMasRapidoQue(unaVelocidadMaxima)
  method manejaUnNoEcologico() = !vehiculo.esEcologico()
  method noLeTocaManejar() = calendario.esDiaPar() && self.dniImpar() || !calendario.esDiaPar() && self.dniPar()

  // Otros
  method esComplicado() = multas.sum({ multa => multa.precioMulta()}) > 50000

  method puedePagar(unPrecio) = dineroEnCuenta >= unPrecio
  method dineroEnCuenta() = dineroEnCuenta
  method gastar(unaCantidad) {
    dineroEnCuenta -= unaCantidad
  }
}

class Multa {
  var estaPaga = false
  var property precioMulta

  method fuePagada() { estaPaga = true } 
  method subirPrecio() { precioMulta =  precioMulta * 1.1 }
}
object shell {
  method precioCombustible() = 160

  method precioFinal(unosLitros) = unosLitros * self.precioCombustible()
}

object calendario {
	method esDiaPar(){
		return new Date().day().even()
	}
}

/*
Usuario
  username, DNI, dinero, vehiculo, registro de multas // atributos
  recorrer una distancia = conducir() // metodos
  recargar combustible
  Pagar multa

Multa
  costo // atributos
  esta pagada (Sí/No) // metodos
  subirPrecio

Vehiculo
  capacidad de tanque; cantidad de combustible; Vel prom; bool esEcológico // atributos
  Cargar Tanque // metodos
  Recorrer distancia -> Comsumir combustible

Zona
  Vel Max permitida, usuarios transitando, controles // atributos
  Control Poner multas // metodos

App
  Todos usuarios, todas zonas // atributos
  Que los usuarios paguen multas -> aumentar si no pagan // metodos
  zona transitada
  usuarios complicados
*/ 