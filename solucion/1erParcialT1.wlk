// PARCIAL TEMA 1 2025

class Juez {
    const property nombre
}
class Causa {
  const jueces = []
  var property montoBase
  method perjuicioEconomico() {
    montoBase + self.montoExtra()
  }
  method montoExtra()
   method tieneJuezAmigo(juez) {
    jueces.any{j => j == juez}
  }
  method aumentarMontoBaseEn(valor) {
    montoBase = montoBase + valor
  }
}

class Soborno inherits Causa {
  var property hayArrepentidos
  override method montoExtra() {
    //hayArrepentidos ? 1 : 2
  }
}

class ObraPublica inherits Causa {
  override method montoExtra() {
    //jueces.size() > 2 ? 2 : 0
  }
}

class Compleja inherits Causa {
  const subCausas = []
  override method montoExtra() {
    subCausas.sum {c => c.perjuicioEconomico()}
  }
}

class Funcionario {
  var property nombre
  var property patrimonio
  var property causas = []
  var property propuestas = []
  var property cargo // instancia de clase Cargo

  method comerse(causa) {
    cargo.validarCausaPara(self, causa)
    causas.add(causa)
  }
  method causasTrambolikas() {
    causas.filter{c => c.esTramboliko()}
  }
  method salirEnMedios() {
    causas.forEach{c => c.aumentarMontoBaseEn(0.1)}
  }
  method escucharPropuesta(propuesta) {
    cargo.procesarPropuestaPara(self, propuesta)
  }
}

class Ejecutivo {
  var property juezAmigo
  var property palabrasClave = ["aumento", "impuestos", "inflación"]

  method validarCausaPara(funcionario, causa) {
    if (funcionario.patrimonio() < causa.perjuicioEconomico())
      throw new Exception(message ="Patrimonio insuficiente")
    if (!causa.tieneJuezAmigo(juezAmigo))
      throw new  Exception(message ="No tiene juez amigo")
  }
}

class Ministro {
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
  var fechaCumplimiento

  method esPedidoCorto() {
    fechaCumplimiento - fechaPresentacion < 365
  }
  method contienePalabraClave(palabra) {
    descripcion.includes(palabra)
  }
  method postergar() {
    fechaCumplimiento = fechaPresentacion + 1460 // 4 años
  }
}