// PARCIAL TEMA 1 2025

class Juez {
    const property nombre
}
class Causa {
  const property jueces = []
  var property montoBase
  var property caratula

  //template method
  method perjuicioEconomico() = montoBase + self.montoExtra()
  method montoExtra()
   
  method aumentarMontoBaseEn(valor) {
    montoBase = montoBase + valor
  }
  //method perjucionMayorA() = self.perjuicioEconomico() * 0.5
}

class Soborno inherits Causa {
  var property hayArrepentidos 
  override method montoExtra() {
   if(hayArrepentidos > 0) 1 else 2
  }
}

class ObraPublica inherits Causa {
  override method montoBase() =  3
  override method jueces() = ["Dr. Ana Lisis", "Dr. Juan Tiler", "Dra. Alina Fante"]

  override method montoExtra() {
   if(jueces.size()< 2 ) 2 else 0 
  }
}

class Compleja inherits Causa {
  const subCausas = []
  override method montoExtra() = subCausas.map {causa => causa.perjuicioEconomico()}. sum()
}

class Funcionario {
  var property patrimonio
  const property causas = []
  var property cargo 
  const property juecesAmigos = []

  method patrimonioMinimo() {
    if (!patrimonio < 0)
      throw new Exception(message = "Patrimonio insuficiente")
  }
  //method patrimonioMaximo() = patrimonio > perjuicioMayorA()
  method aceptarCausa(causa) {
    self.patrimonioMinimo()
    cargo.validarCausa(self, causa)
    causas.add(causa)
  }
  method tieneJuezAmigo(causa) {
    juecesAmigos.any{ juezAmigo => causa.jueces().contains(juezAmigo) }
  }
  method salirEnMedios() {
    causas.forEach{causa => causa.aumentarMontoBaseEn(0.1)}
  }
  method aceptarPropuesta(propuesta) {
    cargo.validarPropuesta(self, propuesta)
  }
}

object ejecutivo {

  method validarCausa(funcionario, causa) {
    if (funcionario.patrimonio() < causa.perjuicioEconomico())
      throw new Exception(message ="Patrimonio insuficiente")
  }

  method validarPropuesta(propuesta) {
    if (!propuesta.tieneJuezAmigo())
      throw new  Exception(message ="No tiene juez amigo")
  }
}

object ministro {
  method validarCausaPara(funcionario, causa) {
    if (funcionario.patrimonio()< causa.perjuicioEconomico() / 2)
      throw new Exception(message = "Ministro con patrimonio menor al 50% del perjuicio")
  }
  method procesarPropuestaPara(funcionario, propuesta) {
    if (propuesta.esPedidoCorto())
      funcionario.propuestas().add(propuesta)
    else
      propuesta.postergar()
      funcionario.propuestas().add(propuesta)
  }
}

class Propuesta {
  var property descripcion
  var property fechaPresentacion
  var property fechaCumplimiento
  var property palabrasClave = ["aumento", "impuestos", "inflación"]

  method esPedidoCorto() = fechaCumplimiento.year() - fechaPresentacion.year() < 1

  method contienePalabraClave(palabraClave) {
    descripcion.contains(palabraClave)
  }
  method postergar() {
    fechaCumplimiento = fechaPresentacion.plusYears(4)
  }
}