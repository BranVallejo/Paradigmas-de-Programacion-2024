/*
Ejercicio 1 - Pepita básica
Codificar a pepita en Wollok, con estos patrones de modificación de la energía:
cuando vuela, consume un joule por cada kilómetro que vuela, más 10 joules de "costo fijo" en cada vuelo.
cuando come, adquiere 4 joules por cada gramo que come.
No olvidar la inicialización.
Pepita ahora es mensajera, le enseñamos a volar sobre la ruta 9.
Agregar los siguientes lugares sobre la ruta 9, con el kilómetro en el que está cada una, y agregar lo que haga
falta para que:
pepita sepa dónde está (vale indicarle un lugar inicial al inicializarla).
le pueda decir a pepita que vaya a un lugar, eso cambia el lugar y la hace volar la distancia.
pueda preguntar si pepita puede o no ir a un lugar, puede ir si le da la energía para hacer la distancia entre
donde está y donde le piden ir.
Por ahora no validamos cuando le pedimos que vaya que pueda ir, eso lo agregaremos más adelante.
Pensar en particular
qué objeto se debe encargar del cálculo de la distancia entre dos lugares, piensen cómo lo preguntarían desde la consola. 
Si resulta que el cálculo se repite para distintos objetos… OK, después vamos a ver cómo arreglar eso.
cómo hago para no repetir en distintos métodos de pepita la cuenta de la energía que necesita para moverse una cantidad de kilómetros.
*/
// ** CODIGO **
/*
object pepita {
var joules = 100
var lugarUbicada = inicioDeRuta

method volar(kilometro) {
joules = joules - kilometro * 1 - 10
}

method comer(gramo) {
joules = joules + gramo * 4
}

method dondeEsta() { return lugarUbicada } // getter

method lugarUbicada(lugar) { //setter
lugarUbicada = lugar
}

method irA(lugar) {
var distanciaAVolar = self.distanciaEntre(lugarUbicada, lugar)
self.volar(distanciaAVolar)
self.lugarUbicada(lugar)
}

method distanciaEntre(unLugar, otroLugar) {
var diferencia = unLugar.kilometro() - otroLugar.kilometro()
diferencia = diferencia.abs()
return diferencia  
}


method puedeIrA(lugar){
var distanciaAVolar = lugar.kilometro()
return joules > distanciaAVolar + 10
}
}

object inicioDeRuta{
var kilometro = 0
method kilometro() { return kilometro }
}
object unLugar {
var kilometro = 10
method kilometro() { return kilometro }
}

object otroLugar {
var kilometro = 13
method kilometro() { return kilometro }
}

object lugarLejos {
var kilometro = 1300
method kilometro() { return kilometro }
}
*/
/*Preguntas:
Uso siempre el method kilometro en cada lugar, debe haber otra forma de hacerlo.
*/
/*
Ejercicio 2 - Tom y Jerry
A)  Implementar en Wollok un objeto que represente a tom, que es un gato.
Lo que nos interesa de tom es manejar su energía y su velocidad, que dependen de sus actividades de comer ratones
y de correr. 
La persona que registra las actividades de tom, registra los ratones que come y la cantidad de tiempo que corre 
en segundos. 
Cuando tom come un ratón, su energía aumenta en (12 joules + el peso del ratón en gramos). La 
velocidad de tom es 5 metros x segundo + (energia medida en joules / 10). 
Cuando tom corre, su energía disminuye en (0.5 x cantidad de metros que corrió). Observar que la cuenta está en
joules consumidos por metro, pero cuando me dicen cuánto corrió, me lo dicen en segundos. La velocidad que se 
toma es la que corresponde a la energía de Tom antes de empezar a correr, y no varía durante una carrera.
Nota: además de tom, hay otros objetos en juego, ¿cuáles son, qué mensaje tienen que entender?
*/
/*B)  Lograr que tom entienda el mensaje:
tom.meConvieneComerRatonA(unRaton, unaDistancia)
Devuelve true si la energía que gana por comer al ratón es mayor a la que consume corriendo la distancia, que 
está medida en metros.*/
// ** CODIGO **
/*
object tom{
var energia = 100 //Joules
var velocidad = 5 + (energia / 10)

//A)
method comerRaton(unRaton) {
var pesoDelRaton = unRaton.peso()
energia = energia + 12 + pesoDelRaton
velocidad = 5 + (energia / 10)
}

method correr(segundos) {
var metros = self.calcularMetros(segundos)
energia = energia - 0.5 * metros
}

method calcularMetros(segundos) {
var metrosRecorridos = velocidad * segundos     
return metrosRecorridos
}
method meConvieneComerRatonA(unRaton, unaDistancia) {
var energiaPorComer = self.energiaGanadaAlComer(unRaton)
var energiaPorCorrer = self.energiaPerdidaAlCorrer(unaDistancia)
return energiaPorComer > energiaPorCorrer 
}

method energiaGanadaAlComer(unRaton) {
var pesoDelRaton = unRaton.peso()
return 12 + pesoDelRaton
}

method energiaPerdidaAlCorrer(unaDistancia) {
return unaDistancia * 0.5
}
}

object unRaton {
var peso = 50 // en gramos
method peso() {
return peso
}
}

object otroRaton {
var peso = 150 // en gramos
method peso() {
return peso
}
}
*/
/* Ejercicio 3 - Sueldo de Pepe
Implementar en Wollok los objetos necesarios para calcular el sueldo de Pepe.
El sueldo de pepe se calcula así: sueldo = neto + bono x presentismo + bono x resultados.
El neto es el de la categoría, hay dos categorías: gerentes que ganan $1000 de neto, y cadetes que ganan $1500.
Hay dos bonos por presentismo:
* Es $100 si la persona a quien se aplica no faltó nunca, $50 si faltó un día, $0 en cualquier otro caso;
* En el otro, nada.
Hay tres posibilidades para el bono por resultados:
* 10% sobre el neto
* $80 fijos
* O nada
Jugar cambiándole a pepe la categoría, la cantidad de días que falta y sus bonos por presentismo y por resultados;
y preguntarle en cada caso su sueldo.
Nota: acá aparecen varios objetos, piensen bien a qué objeto le piden cada cosa que hay que saber para poder 
llegar al sueldo de pepe. */
//                                              *CÓDIGO*
/*
object pepe {
  var categoria = cadete // gerente o cadete
  var tipoPresentismo = bonoPresentismo // bonoPresentismo o nadaPresentismo
  var tipoResultados = porcentual // porcentual, fijo, nadaResultados
  var faltas = 1

  method sueldo () {
    return  self.neto() + self.presentismo() + self.resultados()
  }

  method neto() {
    return categoria.dinero()  // está mal que en los 3 el método se llame dinero?
  }

  method presentismo() {
    return tipoPresentismo.dinero(faltas)
  }

  method resultados() {
    return tipoResultados.dinero(self.neto())
  }

}

object gerente {
  method dinero() = 1000
}

object cadete {
  method dinero() = 1500
}

object bonoPresentismo{
  method dinero(faltas) {
      if (faltas == 0) {
      return 100
    } else if (faltas == 1) {
      return 50
    } else {
      return 0
    }
  }
}

object nadaPresentismo{
  method dinero(faltas) = 0
}

object porcentual{
  method dinero(sueldoNeto) = sueldoNeto * 0.1
}

object fijo{
  method dinero(sueldoNeto) = 80
}

object nadaResultados{
  method dinero(sueldoNeto) = 0
}
*/
/*
Ejercicio 4 - Celulares
Se pide representar con objetos a personas que hablan entre sí por celulares.
Juliana tiene un Samsung S21, y Catalina tiene un iPhone.
El Samsung S21 pierde 0,25 "puntos" de batería por cada llamada, y el iPhone pierde 0,1% de la duración de cada llamada en batería. Ambos celulares tienen 5 "puntos" de batería como máximo.
Implementar a Juliana, Catalina, el Samsung S21 de Juliana y el iPhone de Catalina en Wollok y hacer pruebas en donde Juliana y Catalina se hagan llamadas telefónicas de distintas duraciones.
Conocer la cantidad de batería de cada celular.
Saber si un celular está apagado (si está sin batería).
Recargar un celular (que vuelva a tener su batería completa).
Saber si Juliana tiene el celular apagado; saber si Catalina tiene el celular apagado.
Ahora podemos también tener en cuenta el costo de las llamadas que se hacen entre Catalina y Juliana. Catalina tiene 
contratado como servicio de telefonía celular a Movistar, Juliana a Personal. Movistar cobra fijo $60 final el minuto,
Claro cobra $50 el minuto + 21% de IVA y Personal $70 final los primeros 10 minutos que usaste el celu, y $40 el minuto
el resto. Se pide hacer un diagrama de objetos que represente esto y saber cuánta plata gastó cada uno luego de haberse
hecho varias llamadas entre sí.
*/
// *CODIGO*
/*
object juliana {
  var celular = samsungS21
  var telefonia = personal
  var gastosDeLlamada = 0

  method llamar(persona, minutos) {
    celular.llamado(minutos)
    persona.recibirLlamado(minutos)
    gastosDeLlamada = gastosDeLlamada + telefonia.cobrarLlamada(minutos)
  }

  method recibirLlamado(minutos) {
    celular.llamado(minutos)
    gastosDeLlamada = gastosDeLlamada + telefonia.cobrarLlamada(minutos)
  }

  method tieneElCelularApagado() {
    return celular.estaApagado()
  }

  method gastosDeLlamada() = gastosDeLlamada
}

object catalina {
  var celular = iPhone
  var telefonia = movistar
  var gastosDeLlamada = 0

  method llamar(persona, minutos) {
    celular.llamado(minutos)
    persona.recibirLlamado(minutos)
    gastosDeLlamada = gastosDeLlamada + telefonia.cobrarLlamada(minutos)
  }

  method recibirLlamado(minutos) {
    celular.llamado(minutos)
    gastosDeLlamada = gastosDeLlamada + telefonia.cobrarLlamada(minutos)
  }

  method tieneElCelularApagado() {
    return celular.estaApagado()
  }

  method gastosDeLlamada() = gastosDeLlamada
}

object samsungS21 {
  var bateria = 5
  method bateria() = bateria
  method bateria(unaBateria) {bateria = unaBateria}
  method estaApagado() = bateria == 0
  method recargar () {self.bateria(100)}
  method llamado(minutos) {bateria = bateria - 0.25}
}

object iPhone {
  var bateria = 5
  method bateria() = bateria
  method bateria(unaBateria) = bateria = unaBateria
  method estaApagado() = bateria == 0
  method recargar () = self.bateria(100)
  method llamado(minutos) {bateria = bateria - 0.001 * minutos}
}

object movistar {
   method cobrarLlamada(minutos) = minutos * 60
}

object personal {
  method cobrarLlamada(minutos) = if (minutos > 10) 70 + 40 * (minutos - 10) else 70
}

object claro {
  method cobrarLlamada(minutos) = (50 * minutos) * 1.21
}

*/
/*
¿Qué objeto me conviene que conozca a la compañía telefónica? 
  Los minutos, las 3 lo necesitan para poder calcular el costo de la llamada
¿Qué debería pasar con los gastos de llamadas si a Juliana se le rompe su celular y se compra uno nuevo?
Se mantienen y seguiran funcionando ya que son una variable del estado interno del objeto persona
*/
/*
Ejercicio 8 - Más Celulares
Agregar al modelo armado para el ejercicio de celulares lo siguiente:
Revisar si como está lo que hiciste, crear una persona nueva es fácil o no; si para crear una persona hay que repetir código, pensar cómo hacer para que no sea así.
Crear a Juan, que tiene un iPhone; este iPhone no es el mismo aparato que el de Catalina, pero se porta igual. Juan contrató a Personal.
Crear a Ernesto, que también tiene un iPhone, y contrató a Claro.
Armar el diagrama de objetos que queda después de agregar a las dos personas nuevas.
Cambiar la política de Claro, para que cobre 0.50 + IVA por llamada, en lugar de por minuto.
Además de llamadas, se pueden enviar mensajes de texto entre celulares. Siempre que un celular recibe un mensaje lo guarda. Movistar y Claro cobran $0,12 centavos el mensaje, y Personal $0,15.
Hacer que una persona cualquiera le mande un mensaje a otra.
Saber cuántos mensajes le llegaron a una persona.
Saber si una persona recibió un cierto mensaje, o sea, un mensaje con un determinado texto.
Saber si una persona recibió un mensaje que empiece con un determinado texto, por ejemplo, con "Esta noche".
Saber cuánta plata gastó una persona luego de hacer varias llamadas y envíos de mensajes.
*/
// NOTA: Dejo el código del 4 como está y lo modifico acá.
//                                                CÓDIGO
object juliana {
  var celular = samsungS21
  var telefonia = personal
  var gastosDeLlamada = 0

  
  method llamar(persona, minutos) {
    whatsApp.hacerLlamado(self, persona, minutos)
  }

  method atender(minutos) {
    whatsApp.recibirLlamado(self, minutos)
  }

  method tieneElCelularApagado() {
    return celular.estaApagado()
  }

  method gastosDeLlamada() = gastosDeLlamada
}

object catalina {
  var celular = iPhone
  var telefonia = movistar
  var gastosDeLlamada = 0
 

  method llamar(persona, minutos) {
    whatsApp.hacerLlamado(self, persona, minutos)
  }

  method atender(minutos) {
    whatsApp.recibirLlamado(self, minutos)
  }

  method tieneElCelularApagado() {   
    return celular.estaApagado()
  }

  method gastosDeLlamada() = gastosDeLlamada
  method actualizarGastos() = 
}

//La idea es que sea como un gestor de llamadas y mensajes. Evito repetir lógica, más fácil crear personas.
object whatsApp{ 
  method hacerLlamado(emisor, receptor, minutos) {
    emisor.celular().llamado(minutos)
    receptor.atender(minutos)     
    emisor.gastosDeLlamada += emisor.telefonia().cobrarLlamada(minutos) // Está horrible, siento que rompo el encapsulamiento, y la regla del "Tell, don't ask". No se me ocurre como simplificarlo y dejar de repetir lógica. Con clases? Quizás algún método donde le digo a la companía telefonica de cobre los minutos?
  }

  method recibirLlamado(persona, minutos) {
    persona.celular.llamado(minutos)
    persona.gastosDeLlamada += persona.telefonia.cobrarLlamada(minutos)
  }
}

object samsungS21 {
  var bateria = 5
  method bateria() = bateria
  method bateria(unaBateria) {bateria = unaBateria}
  method estaApagado() = bateria == 0
  method recargar () {self.bateria(100)}
  method llamado(minutos) {bateria = bateria - 0.25}
}

object iPhone {
  var bateria = 5
  method bateria() = bateria
  method bateria(unaBateria) = bateria = unaBateria
  method estaApagado() = bateria == 0
  method recargar () = self.bateria(100)
  method llamado(minutos) {bateria = bateria - 0.001 * minutos}
}

object movistar {
   method cobrarLlamada(minutos) = minutos * 60
}

object personal {
  method cobrarLlamada(minutos) = if (minutos > 10) 70 + 40 * (minutos - 10) else 70
}

object claro {
  method cobrarLlamada(minutos) = (50 * minutos) * 1.21
}




/*
Ejercicio 5 - Mudanzas
Describa qué comportamiento espera una iempresa de mudanzas de un objeto que representa una silla y otro que representa un televisor; o sea qué mensajes les podría enviar y qué respuestas serían razonables. ¿Hay comportamiento en común? ¿Hay interfaz en común? Por ejemplo, de ambos me va a interesar el peso.
¿Qué otros objetos que maneja la empresa de mudanzas podría interactuar con sillas y televisores? Por ejemplo, camión ... el resto piénselo uds.. Pensar qué mensajes le enviarían estos objetos a sillas y televisores.
Implementar con Wollok dos sillas y tres televisores, un camión, y alguna interacción entre los mismos, en particular, el control del peso máximo que puede transportar un camión. Se puede suponer que un camión puede llevar como máximo 3 cosas.
Realice un diagrama donde los objetos anteriores se interrelacionen.
Indique otros observadores que podrían interactuar con sillas y televisores, y qué comportamiento esperan.
Salteado, ejercicio raro.*/

/*
Ejercicio 6 - Mueblería
Relacione sillas, mesas y televisores según la visión de un vendedor de una tienda de hogar, respecto del acto de venderlos más que de los argumentos de venta (precio, hasta cuántas cuotas, etc.).
Suponer que nos interesa: armar una venta que puede vender un artículo a un cliente, para la venta se pueden establecer condiciones particulares (Por ejemplo, cantidad de cuotas, descuento, fecha de entrega); y también poder reservar un artículo para un cliente.
¿Qué comportamiento y características de los objetos le son interesantes al vendedor?
Para definir una venta, además del artículo (mesa o silla) ¿qué objeto/s viene/n bien?
¿Qué colaboraciones puede encontrar?
Implementar en Wollok una silla, una mesa, y lo que haga falta para reservarlas y venderlas.*/




/*
Ejercicio 7 - Pepita reloaded & Friends
Agregar al modelo armado para el ejercicio de pepita lo siguiente:
Si le pido a pepita que vuele a un lugar, y no puede, no haga nada.
Poder decirle a pepita que haga su deseo, que consiste en lo siguiente
si está eufórica, que vuele 5 kilómetros (en redondo, no cambia de lugar).
si está débil, que coma 500 gramos.
pepita está cansada o débil si tiene menos de 50 joules, y está eufórica si: tiene más de 500 joules, y además su energía es par. Recordar que a los números les puedo preguntar si son pares o no, con el mensaje even().
Agregar entrenadores, cada entrenador hace una rutina distinta, se le pasa un ave (por parámetro de un mensaje) y le hace la rutina.
Por ejemplo, tenemos a roque y a susana
la rutina de roque es: volar 5 km, comer 300 gramos, volar otros 3 km.
la rutina de susana es: volar 3 km, y hacerla hacer su deseo.
Pepita tiene un entrenador, que puede ir cambiando con el tiempo. Por ejemplo, hoy el entrenador de pepita es roque, mañana cambia a susana.
Agregar esto al modelo de forma tal que pueda decirle a pepita que se entrene, enviándole el mensaje entrenate.
Agregar a pepón, que es un gorrión con estas características:
al volar consume 2 joules por kilómetro, pero sin costo fijo.
al comer adquiere 3 joules por gramo, menos 20 joules de costo fijo por digerir.
su deseo es siempre comer 100 gramos.
también tiene un entrenador, y le puedo decir que entrene.
no es mensajero, por lo tanto, no nos importa dónde está ni pedirle que vaya a un lugar.
agregar a luciana y ernestina, que son otras dos golondrinas, que sí son mensajeras con la misma onda que pepita. Verificar que:
les puedo decir lo mismo que a pepita, y tienen los mismos patrones de comportamiento.
si le digo a luciana que vuele, baja la energía de luciana, pero no la de pepita ni la de ernestina.
cambiar la implementación de los lugares, para no tener que repetir código entre ellos.


Todo lo que viene abajo, debería hacerse en un solo objeto, y que ande para todas las personas. Está relacionado con lo que preguntamos en el punto a. de este ejercicio.
Ejercicio 9
Indicar qué objetos aparecen y cómo colaboran para resolver los siguientes problemas:
Un estudiante desea anotarse en las materias de este cuatrimestre. Para esto necesita: saber qué cursos hay de cada materia y sus profesores, controlar no anotarse en dos materias a la misma hora, controlar que tiene las correlativas.
b. Un zorro busca alimento en un gallinero donde hay gallinas, patos, gallos y huevos; donde cada posible comida tiene una energía, un sabor y un grado de peligrosidad.
Observar:
¿Qué objetos intervienen? No limitarse necesariamente a los objetos físicos. En particular, si aparece la necesidad de objetos que representen conjuntos, pensar qué mensajes deberían entender.
¿Cómo se envían los mensajes? ¿Qué argumentos?
Ejercicio 10
juan.peso()
sillaDeLaCocina.peso()
Estos dos objetos ¿son polimórficos?
Ayuda: pensar en el "tercer objeto" de la definición de polimorfismo.
Ejercicio 11
Una biblioteca tiene sus libros clasificados en informática, filosofía, matemáticas, derecho y
economía.
Desea poder preguntarle a los objetos que representan libros por cuánto tiempo los pueden prestar. Los libros de informática y filosofía se prestan por dos semanas, los de matemática por 1 semana si tienen 1 capítulo y por 3 semanas si tienen dos o más capítulos; cualquier otro libro se presta por 5 semanas.
Realizar y codificar una solución a este problema.
*/
