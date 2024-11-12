import actividad.*
import argumento.*

class Filosofo {
  const nombre
  const honorificos = #{}
  var nivelDeIluminacion
  const actividades = []
  var dias

  // 1
  method presentarse() = self.nombre() + " " + self.honorificosAString(honorificos)

  method honorificosAString(unosHonorificos) = honorificos.join(", ")
  
  // 2
  method estaEnLoCorrecto() = self.nivelDeIluminacion() > 1000
  
  
  method rejuvenecer(unosDias) {
    dias -= unosDias
  }

  // 3
  method vivirUnDia(){
    self.hacerActividades()
    self.envejecer()
    self.verificarSiEstaDeCumpleanios()
  }

  method hacerActividades() {
    actividades.forEach({ actividad => actividad.afectar(self) })
  }

  method verificarSiEstaDeCumpleanios() {
    if (dias % 365 == 0) {
      self.subirIluminacion(10)
      self.verificarSiSeraSabio()
    }
  }

  method verificarSiSeraSabio() {
    if(self.edad() == 60) {
      self.agregarHonorifico("el sabio")
    }
  }

  method agregarHonorifico(unHonorifico) {
    honorificos.add(unHonorifico)
  }

  method subirIluminacion(unaCantidad) {
    nivelDeIluminacion += unaCantidad
  }
  method bajarIluminacion(unaCantidad) {
    nivelDeIluminacion -= unaCantidad
  }
  method nombre() = nombre
  method nivelDeIluminacion() = nivelDeIluminacion
  method edad() = (dias / 365).round()
  method envejecer() {
    dias += 1
  }
  
}

class Contemporaneo inherits Filosofo {
  const amaAdminarElPaisaje = actividades.contains(admirarElPaisaje)

  override method presentarse() = "hola"
  override method nivelDeIluminacion() = super() * self.multiplicadorDeIluminacion()

  method multiplicadorDeIluminacion() = if (amaAdminarElPaisaje) 5 else 1
}




/*
Filosofos:
  nombre, edad, actividades, honorificos, nivel de iluminacion
  presentarse()
  estaEnLoCorrecto()

Actividades
  lista dentro de cada filosofo
  pasarUnDia() hacer actividades
  class Actividad, despues todos objectos
  const pablo = new Filosofo (nombre = "Pablo", honorificos = #{"alto, gracioso"} )
  
*/
