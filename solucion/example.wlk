// TP1 OBJETOS

// Todos los Intregrantes (Instrumentos)
 
/*object guitarraFender {
    method instrumento(guitarra) {
        guitarra.afinado()
        guitarra.costo()
        guitarra.esValioso()
    }
    
}
object guitarraFenderNegra{
    const color = "negra"

    method afinado() = true
    method costo() = if (color == "negra") 15 else 10
    method esValioso() = true
} 
object guitarraFenderRoja{
    const color = "roja"

    method afinado() = true
    method costo() = if (color == "roja") 15 else 10
    method esValioso() = true
} */

//Integrante 1
object trompetaJupiter {
   
}

//Integrante 2

object pianoBechstein {
    const anchoHabitacion = 5
    const largoHabitacion = 5
    var fechaUltimaRevision = "2025-10-01"

    method metrosCuadrados() = anchoHabitacion * largoHabitacion
    method afinado() = self.metrosCuadrados() > 20
    method costo() = 2 * anchoHabitacion
    method esValioso() = self.afinado()

    method revisar(fecha) {
        fechaUltimaRevision = fecha
    }
}
//Integrante 3


// Todos los Intregrantes (Musicos)
object johann {
    const instrumento = trompetaJupiter

    method esFeliz() = instrumento.costo() > 20
}
object wolfgang {
    method esFeliz() = johann.esFeliz()
}

//Integrante 1

//Integrante 2
/*object giuseppe {
    const instrumento = guitarraFenderNegra

    method esFeliz() = instrumento.estaAfinada()
}
*/
//Integrante 3