import argumento.*
import filosofo.*

class Actividad {

    method afectar(unFilosofo)
}

object tomarVino inherits Actividad {
    override method afectar(unFilosofo) {
        unFilosofo.bajarIluminacion(10)
        unFilosofo.agregarHonorifico("El borracho")
    }
}

object admirarElPaisaje inherits Actividad {
    override method afectar(unFilosofo) {}
}

class JuntarseEnElAgora inherits Actividad {
    const otroFilosofo

    override method afectar(unFilosofo) {
        unFilosofo.subirIluminacion(otroFilosofo.nivelDeIluminacion())
    }
}

class MeditarBajoUnaCascada inherits Actividad {
    const largoDeCascada
    override method afectar(unFilosofo) {
        unFilosofo.subirIluminacion(largoDeCascada * 10)
    }
}

class PracticarDeporte inherits Actividad {
    method diasRejuvenecidos()
    
    override method afectar(unFilosofo) {
        unFilosofo.rejuvenecer(self.diasRejuvenecidos())
    }
}

object futbol inherits PracticarDeporte {
    override method diasRejuvenecidos() = 1
}

object polo inherits PracticarDeporte {
    override method diasRejuvenecidos() = 1
}

object waterPolo inherits PracticarDeporte {
    override method diasRejuvenecidos() = polo.diasRejuvenecidos() * 2
}
/*
Filosofos:
  nombre, edad, actividades, honorificos, nivel de iluminacion
  presentarse()
  estaEnLoCorrecto()

  vivirUnDia() hacer actividades 

Actividades
  lista dentro de cada filosofo
  class Actividad, despues todos objectos
  const pablo = new Filosofo (nombre = "Pablo", honorificos = #{"alto, gracioso"} )
*/
