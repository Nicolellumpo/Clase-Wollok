//EJECICO PRE-PARCIAL - Noticias de ayer , extra

//Punto 1 
class Noticia {
  const property fecha 
  var property periodista
  var property importancia
  var property titulo
  var property desarrollo 

  method esCopada() =
    self.tieneImportanciaSuficiente() &&
    self.esReciente() &&
    self.criterioCopada()

  method tieneImportanciaSuficiente() = importancia >= 8
  method esReciente() = fecha > new Date().minusDays(3)
  method criterioCopada()

  method cantidadPalabras() = desarrollo.size()
  method estaBienEscrita() =titulo.size() >= 2 && desarrollo.size() > 0

  method esPreferidaPorSensacionalista() = false

}

class ArticuloComun inherits Noticia {
  var property  links = []
  override method criterioCopada() = links.size() >= 2
}

class Chivo inherits Noticia {
  const montoPagado
  override method criterioCopada() = montoPagado > 2000000
}

class Reportaje inherits Noticia {
  const property entrevistado
  override method criterioCopada() = entrevistado.size().odd()
  override method esPreferidaPorSensacionalista() = entrevistado == "Dibu Martínez"
}
class Cobertura inherits Noticia {
  const property relacionadas = []
  override method criterioCopada() = relacionadas.all({noticia => noticia.esCopada()})
}
//Punto 2
class Periodista {
  var property nombre
  const property fechaIngreso
  const property noticiasPublicadas = []

  method esReciente() = fechaIngreso > new Date().minusYears(1)
  method prefiere(noticia)

 //Punto 3
  method puedePublicar(noticia) {
    
    const noticiasHoy = noticiasPublicadas.filter({ noticia => noticia.fecha()== new Date() })
    const noPreferidasHoy = noticiasHoy.filter({ noticia => !self.prefiere(noticia) })
    return self.prefiere(noticia) || noPreferidasHoy.size() < 2
  }
  method publicar(noticia) {
    if (!self.puedePublicar(noticia)) {
      throw new Exception(message = "No puede publicar más noticias no preferidas hoy")
    }
    if (!noticia.estaBienEscrita()) {
      throw new Exception(message = "La noticia no está bien escrita")
    }
    noticiasPublicadas.add(noticia)
  }
}

class Copado inherits Periodista {
  override method prefiere(noticia) = noticia.esCopada()
}

class Sensacionalista inherits Periodista {
  override method prefiere(noticia) =
    noticia.titulo().contains("espectacular") || 
    noticia.titulo().contains("increíble") || 
    noticia.titulo().contains("grandioso") ||
    noticia.esPreferidaPorSensacionalista()
}

class Vago inherits Periodista {
  override method prefiere(noticia) =
    Chivo || noticia.cantidadPalabras() < 100
}

class JoseDeZer inherits Periodista {
  override method prefiere(noticia) = noticia.titulo().startsWith("T")
}

//Punto 4
object multimedio {
  var property periodistas = []

  method periodistasRecientesActivos() =
    periodistas.filter({periodista =>
      periodista.esReciente() && periodista.any({noticia => noticia.fecha().daysTo(new Date()) <= 7})
    })
}



