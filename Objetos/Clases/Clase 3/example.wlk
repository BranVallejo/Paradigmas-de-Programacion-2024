// Objeto: 
//Temas vistos: Clases, Colisión, Colecciones
/*
                                               Notas:
  Si hace algo, NO devuelve. Ej: .add()
  Colecciones:
  Colecciones: Contenedores que contienen datos. Ej: Listas es un tipo de colección,

    * Listas.(List).[]  
      Está indexada en base 0.
      Tiene orden, tiene index.
      Puede tener elementos repetidos.
      El objeto lista es inmutable, pero al agregarle y sacarle elementos, es como si lo fuera. Pero siempre se
      apunta a la misma lista.
      Ejemplos de uso:
      > [2].size()    > 1
      > var miLista = []; > miLista.add("Hola")

    
    * Conjuntos:
      No tiene orden. No está indexada.
      No admite elementos repettidos.
      En el diagrama, sus flechas a objetos no tienen numeros (index). En cambio las listas (que son colecciones)
      sí las tienen.

      Ejemplos de uso:
      > var miSet = #{}; > miSet.add("Hola")

      Obj1 == Obj2 Compara si los 2 tienen los mismos elementos. Ej: Util para listas.
      Obj1 === Obj2 Compara si son los mismos objetos. Pregunta su identidad, si son identicos.   
      Ej:
        > [1,2,3,4] == [1,2,3,4]; > true.
        > [1,2,3,4] === [1,2,3,4]; > false. La lista de la izq y der son 2 objetos diferentes.
      Ej:
        var bar = [1,2]; var foo = [1,2]; var saraza = bar;
        > bar == foo; true.   > bar === foo; false. 
        Son iguales porque tienen los mismos objetos, pero no son identicos porque son diferentes objetos.
        > bar == saraza; true.   > bar === saraza; true. 
        En el diagrama las 2 flechas apuntan al mismo objeto.
        Son iguales porque tienen los mismos objetos, y son identicos porque son el mismo objeto.

*/

/*
  Clases:
    Es un molde para crear objetos.
    Si comparten interfaz, no necesariamente tengo que crear una clase. Quizas ante el mismo mensaje tienen
    comportamientos diferentes.,
    Solo cuando comparten comportamiento.
    Tenemos 2 recitales, crear varios objetos de la misma clase.
    Así abstraigo lógica.
    Hay que instanciarlos
    > const showDeLali = new Recital()

    > var id = {a => a}     
    > id.apply(3) > 3
    Creo un objeto que es un bloque, que es una condición. Para usarlo le mando el mensaje apply.

    > var diceHola = {"Hola"}
    > dice
*/

class Recital {
  var asientos = []


  method venderEntrada(persona) {
    asientos.add(persona)
  }

  method entradasVendidas() = asientos.size()

// En Wollok no hay for o while
  method asientosAsignadosConInicial(inicial) {
    return asientos.filter({ asiento => asiento.startsWith(inicial) }) // Adentro del filter va UN OBJETO, que representa una condicion
  }

}

class Concierto {
  var ubicacion = estadio
  var artista
  var fecha
  
}

objeto river {
  var capacidadMaxima = 1000
  var plateaAlta
}






