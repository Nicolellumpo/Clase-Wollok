class Causa{
    var property montoBase
    const property caratula
    const property jueces = []
    //template method
    method costoPerjucio() =  montoBase + self.costoParticular()
    //method particular del template method
    method costoParticular() 
    method tieneMonstosRaris() = montoBase.odd()
    method tieneMonstosNormales() = montoBase.even()
    method aumentarMontoBase(extra) {
        montoBase = montoBase + extra
    }
}

class DesvioDeFondos inherits Causa{
    var property anioInicio
    override method costoParticular() = self.aniosPendiente() * 1.5
    method aniosPendiente() = new Date().year() - anioInicio.year()
}

class CriptoMonedas inherits Causa(montoBase = 5 , 
    caratula = "estafa" ,
    jueces = ["Dr. Rodolfo Kometa", "Dr. Armando U. Nacausa", "Dr. Jorge Garantis"]){
    //Se puede hacer de las dos formas
    //override method montoBase() = 5 
    //override method caratula() = "estafa"
    //override method jueces() = ["Dr. Rodolfo Kometa", "Dr. Armando U. Nacausa", "Dr. Jorge Garantis"]
    override method costoParticular() = montoBase * 0.3
}
class Compleja inherits Causa{
    var property subCausa = []
    //composite
    override method costoParticular() = subCausa.all{subCausa => subCausa.costoPerjucio()}.sum()
}

class FunciorioPublico {
    const property causas = []
    var property patrimonio 
    var property cargo 
    
    method patrimonioMinimo(){
        if (!patrimonio > 0)
            throw new Exception (message = "Patrimonio insuficiente" )
    }
    method validarPuesto(causa){
        cargo.validarCausa(causa,self)
    }
    method aceptarCausa(causa){
        self.patrimonioMinimo()
        self.validarPuesto(causa)
        causas.add(causa)
    }
    method cambiarCargo(nuevoCargo){
        cargo = nuevoCargo
    }

    method causasRaris() = causas.filter{causa => causa.tieneMonstosRaris()}
    method caratulasConMontoRaris() = self.causasRaris().map{ causa => causa.caratula() }
    method tienePocasCausas() = causas.size() <= 3
    
    method salirEnMedios(){
        causas.forEach{causa => causa.aumentarMontoBase(0.1)}
    }
    method aceptarPropuesta(propuesta) {
        if(!cargo.validarPropuesta(propuesta))
        propuesta.postergar()    
    }

}
object legislador {
    method validarCausa(funcionario , causa){
       if(funcionario.tienePocasCausas())
            throw new DomainException (message = "No puede haber menos de 3 causas" )     
    }
    method validarPropuesta(propuesta){
        if(!propuesta.anioVigente())
            throw new DomainException (message = "Propuesta no vigente" )  
    }   
}

object jefeGobierno {
    method validarCausa(funcionario,causa){
       if(causa.tieneMonstosRaris())
            throw new DomainException (message = "No tiene monto base normal" )     
    }
    method validarPropuesta(propuesta) = propuesta.esTranqui()
}

class Propuesta{
    var property descripcion
    var property fechaPresentacion
    var property fechaCumplimiento
    method postergar(){
        fechaCumplimiento = fechaCumplimiento.plusYears(4)
    }
    method anioVigente(){
        fechaPresentacion.year() ==  new Date().year()
    }
    method esTranqui(){
        descripcion.length() < 15
    }
}
