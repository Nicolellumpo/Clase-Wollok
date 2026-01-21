//----------------------------------------------PRACTICA VIDEO 18  - LA FERIA---------------------------------------------
object tiroAlBlanco { 
    method cantTickets(jugador) = (jugador.punteria() / 10).roundUp()
    method cansancio() = 3 
}
object pruebaDeFuerza {
    method cantTickets(jugador) = if (jugador.fuerza() > 75 ) 20 else 0
    method cansancio() = 8    
}
object ruedaDeLaFortuna {
    var property aceitada = true

    method cantTickets(jugador) = 0.randomUpto(20).randomUp()
    method cansancio() = if (aceitada) 0 else 1
    
}

object julieta {
    var property tickets = 15
    var property cansancio = 0
   // var property fuerza = 80  - cansancio
   // si dejo asi me genera incoerenica es mejor hacer un method

    method punteria() = 20 
    method fuerza() = 80 - cansancio
    
    method jugar(juego){
        tickets = tickets + juego.cantTickets(self)
        cansancio =  cansancio + juego.cansancio()
    }
}

//---------------------------------------------------------PRACTICA VIDEO 20 --------------------------------------------
class Corral{
    const animales = []
    method lecheDisponible(){ animales
        .filter{animal => animal.estaContenta()}
        .sum{animal => animal.litrosDeLeche()}
    }
    method todasContentas(){
        animales.all{animal => animal.estaContenta()}
    }
    method ordenear(){ 
        animales.forEach{animal => if(animal.estaContenta()) animal.ordenear()} 
    }
}
// ----------------------------------------Practica Video 21------------------------------------------------------------------
    class Tanque{
        const armas = []
        const tripulantes = 2
        var salud = 100
        var property prendidoFuego = false

        method emitirCalor() = prendidoFuego || tripulantes > 3 

        method sufrimientoDanio(danio){
            salud = salud - danio
        }

        method atacar(objetivo){
            armas.anyOne().dispararA(objetivo)
        }
    }
    class TaqueBlindado inherits Tanque{
        const blindaje = 200
        override method emitirCalor() = false
        override method sufrimientoDanio(danio){
            if (danio > blindaje)
                super(danio - blindaje)
        }
    }
    class Recargable{
        var property cargador = 100
        method agotada() = cargador <= 0
    }
    class Lanzallamas inherits Recargable{
        method dispararA(objetivo){
            cargador -= 20
            objetivo.prendidoFuego(true)
        }   
    }
  
    class Misil{
        const potencia
        var agotada = false
        method agotada() = agotada
        method dispararA(objetivo){
            agotada = true
            objetivo.sufrimientoDanio(potencia)
        }
    }
    class MisilTermino inherits Misil{
        override method dispararA(objetivo){
            if(objetivo.emitirCalor())
                //como asi sigo repitiendo codigo tengo q usar SUPER
                //agotada = true
               // objetivo.sufrimientoDanio(potencia)
                super(objetivo)
        }
    }
    // al hacer una class Metralla me ahorra a la hora de tener que crear 
    // los dif tipos de metrallas donde solo  pongo la especificacion de potencia
        class Metralla  inherits Recargable{
        const property calibre
        method dispararA(objetivo){
            cargador -= 10 
            if(calibre > 50)
            objetivo.sufrimientoDanio(calibre/4)
        }
    }
//------------------------------------------ Practica Video 22------------------------------------------

    class Personaje {
        var property fuerza
        var property inteligencia
        var property rol

        method cambiarRol(nuevoRol){
            rol = nuevoRol
        }
        method potencialOfensivo() = fuerza * 10 + rol.extra()
        //method esGroso() = self.esInteligente() || self.esGrosoParaSuRol() --- TAMBIEN SE PUEDE HACER ASI
        method esGroso() = self.esInteligente() || rol.esGroso(self)  
        method esInteligente()
        //method esGrosoParaSuRol() = rol.esGroso(self) --- TAMBIEN SE PUEDE HACER ASI
    }
    class RazaOrcos inherits Personaje{
        override method esInteligente() = false
        override method potencialOfensivo() = super()*1.1
    }
    class RazaHumano inherits Personaje{
        override method esInteligente() = inteligencia > 50
    }
    //---------------------------------- Roles 
    class RolGuerrero {
        method extra() =  10
        method esGroso(personaje) = personaje.fuerza() > 50
    }
    class RolBrujo {
        method extra() = 0
        method esGroso(personaje) = true
    }
    class RolCazador {
        var property mascota
        method extra() = mascota.potencialOfensivo()
        //override method extra() = if (mascotaConGarras) fuerza else 2*fuerza
        //es mejor crear una class mascota y no dejarle el peso al rol cazador
        method esGroso(personaje) = mascota.esLongeva()
    }
    class Mascota{
        const property fuerza
        const edad
        const tieneGarras

        method potencialOfensivo() = if (tieneGarras) fuerza* 2 else fuerza 
        method esLongeva() = edad > 10
    }
//----------------------------------ZONA
    class Ejercito{
        const property miembros = []

        method potencialOfensivo() = miembros.sum{personaje => personaje.potencialOfensivo()}
        method invadir(zona){
            if(zona.potencialOfensivo() < self.potencialOfensivo()){
                zona.seOcupadaPor(self)
            }
        }
    }

    class Zona{
        var habitantes 
        method potencialDefensivo() = habitantes.potencialOfensivo()
        method seOcupadaPor(ejercito){
            habitantes = ejercito
        }
    }
    class Ciudad inherits Zona{
        override method potencialDefensivo() = super() + 300
    }
    class Aldea inherits Zona{
        const maxHabitantes = 50

        override method seOcupadaPor(ejercito){
            if(ejercito.miembros().size() > maxHabitantes){
               const nuevosHabitantes = ejercito.miembros().sortBy{uno, otro => uno.potencialOfensivo() > otro.potencialOfensivo()}
               .take(10)
               super(new Ejercito(miembros = nuevosHabitantes))
               ejercito.miembros().removeAll(nuevosHabitantes)
            } else super(ejercito)
        }
    }
    