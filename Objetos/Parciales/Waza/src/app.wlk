import usuario.*
import vehiculo.*
import zona.*

object app {
  const usuarios = #{}
  const zonas = #{}

  method zonaMasTransitada() = zonas.max({ zona => zona.cantidadDeUsuarios() })
  method usuariosComplicados() = usuarios.filter({ usuario => usuario.esComplicado() })
  method pagarMultas() = usuarios.forEach({ usuario => usuario.pagarLasMultas() })
}