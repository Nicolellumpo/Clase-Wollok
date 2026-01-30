//Paractica video 25 
class SuperCompu{
    var property equipos = []
    var property totalDeComplejidadComputadora 
   
    method estaActivo() = equipos.filter{equipo => equipo.activo()}
    method activo() = true

    method computo() = self.estaActivo().sum{equipo => equipo.computo()} 
    method consumo() = self.estaActivo().sum{equipo => equipo.consumo()}
    method capacidad() = self.computo() + self.consumo() 
    // esta bien si devulevo la capacidad como la suma del computo y consumo?

    /* esto esta mal hecho

    1. && - evuelve un booleano, no un número.
    2. sum() - no tiene sentido usarlo en un booleano.
    method capacidad() = 
        if (self.estaActivo()) 
        equipos.sum{equipo => equipo.computo() && equipo.consumo()}
    */
    method malConfigurada() = self.equipoQueMasConsume() != self.equipoQueMasProduce()
    method equipoQueMasConsume() = self.estaActivo().max{equipo => equipo.consumo()}
    method equipoQueMasProduce() = self.estaActivo().max{equipo => equipo.computo()}

    method consumoElectrico() 
    method producenComputo() 

    method computar(problema){
        self.estaActivo().forEach{equipo => 
            equipo.computar(new Problema(complejidad = problema.complejidad()/ self.estaActivo().size()))
        }
        totalDeComplejidadComputadora += problema.complejidad()
    }
}
class Problema{
    const property complejidad

}
class Equipo {
    var property modo = Standard
    var property estaQuemado = false

    method consumo() = modo.consumoDe(self)
    method computo() = modo.computoDe(self)
    method activo() = !estaQuemado && self.computo() > 0

    method consumoBase()
    method computoBase()
    method extra()
    method computar(problema){
        if(problema.complejidad()> self.computo())
            throw new DomainException(message="Capacidad excedida")
            modo.realizoComputo(self)
    }
}

class EquipoA105 inherits Equipo {
    override method consumoBase() = 300
    override method computoBase() = 600
    override method extra() = self.computoBase() * 0.3
    override method computar(problema){
       if(problema.complejidad() < 5)
            throw new DomainException(message="Error de fabrica")
            super(problema)
    }
}
class EquipoB2 inherits Equipo{
    var property microChip

    override method consumoBase() = 50 * microChip + 10
    override method computoBase() = 800.min(100 * microChip)
    override method extra() = 20 * microChip
}
//modos
class Standard{
    method consumoDe(equipo) = equipo.consumoBase()
    method computoDe(equipo) = equipo.computoBase()
    method realizoComputo(equipo){}
}
class Overclock{
    var usosRestantes
    
    override method initialize(){
        if(usosRestantes<0)
        throw new DomainException(message="Losusos restantes deben ser mayor a 0")
    } 
    method realizoComputo(equipo){
        if(usosRestantes == 0){
            equipo.estaQuemado(true)
            throw new DomainException(message = "Equipo quemado")
        }
        usosRestantes -= 1
    }
    method consumoDe(equipo) = equipo.consumoBase()*2
    method computoDe(equipo) = equipo.computoBase() + equipo.extra()
    //method extra()+ self.extra()
    // me falta agregar esto un equipo sólo podrá usarse  cierta cantidad de veces antes de quemarse 
    //(el número exacto es arbitrario y varía cada vez se overclockea). Cada vez que la super-compudora 
    //computa, sus equipos en modo overclock son usados, si esto ocurre las veces necesarias el equipo 
    //pasa a estar quemado.
}
class AhorroEnergia {
    var computoRealizados

    method consumoDe(equipo) = 200
    method computoDe(equipo) = self.consumoDe(equipo) / equipo.consumoBase() * equipo.computoBase() 
    method periodicidadDeError() = 17
    method realizoComputo(equipo){
        computoRealizados += 1
        if(computoRealizados % self.periodicidadDeError() == 0)
        throw new DomainException(message= "Corriendo Monitor")
    }
}

class ApruebasDeFallos inherits AhorroEnergia{
    override method computoDe(equipo) = super(equipo)/2
    override method periodicidadDeError() = 100
}