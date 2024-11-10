import usuario.*
import vehiculo.*
import app.*

class Zona {
    const velocidadMaxima
    const usuarios = #{}
    const controles = #{}

    method activarControles() {
        controles.forEach( {control => control.controlarUsuarios(usuarios, velocidadMaxima)} )
        //Se me hace raro tener que pasarle así el dato de vel máx, pero no le encontré otra
    }

    method cantidadDeUsuarios() = usuarios.size()
    method velocidadMaxima() = velocidadMaxima
}

class Control {
    method  controlarUsuarios(unosUsuarios, unaVelocidadMaxima) {
        unosUsuarios.filter( { unUsuario => self.infringeElControl(unUsuario, unaVelocidadMaxima) } )
        self.aplicarMultas(unosUsuarios)
    }

    method infringeElControl(unUsuario, unaVelocidadMaxima)
   
    method aplicarMultas(unosUsuarios) {
        unosUsuarios.forEach({ unUsuario => self.multar(unUsuario) })
    }
    method multar(unUsuario) {
        const unaMulta = new Multa ( precioMulta = self.importeAPagar())
        unUsuario.recibirMulta(unaMulta)
    }

    method importeAPagar() // cada objeto lo cambia
}

object velocidad inherits Control {
    override method infringeElControl(unUsuario, unaVelocidadMaxima) = unUsuario.pasadoDeVelocidad(unaVelocidadMaxima)
    override method importeAPagar() = 3000
}

object ecologico inherits Control {
    override method infringeElControl(unUsuario, unaVelocidadMaxima) = unUsuario.manejaUnNoEcologico()
    override method importeAPagar() = 1500
}
object regulatorio inherits Control {
    override method infringeElControl(unUsuario, unaVelocidadMaxima) =  unUsuario.noLeTocaManejar()
    override method importeAPagar() = 2000
}
