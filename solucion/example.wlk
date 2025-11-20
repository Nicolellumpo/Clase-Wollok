//EJECICO PRE-PARCIAL - Noticias de ayer , extra

//Punto 1 
class Noticia {
  const property fecha 
  const property importancia // es const para q sea mas mutable
  var property titulo
  var property desarrollo 
 
 //Template Method 
  method esCopada() =
    self.esSuficiente() &&
    self.esReciente() &&
    self.criterioCopada() // es la condicion particulat de template method

  method esSuficiente() = importancia >= 8
  method esReciente() = fecha > new Date().minusDays(3) // tambein es valido 
  // method esReciente() = new Date() - fecha < 3 
  method criterioCopada()

  method cantidadPalabras() = desarrollo.size()
  method estaBienEscrita() =titulo.size() >= 2 && desarrollo.size() > 0

  //method esPreferidaPorSensacionalista() = false

  method esSensacionalista() = 
    self.titulo().contains (["espectacular" , "increíble" , "grandioso"])

  method tituloContienePalabras(palabras) =
    palabras.any{ palabra => titulo.contains(palabra) }

  method aptaParaVago() = desarrollo.words().length()<100

  method esPreferidoPorAutor() = autor.prefiere(self)
}

class ArticuloComun inherits Noticia {
  const links = []
  override method criterioCopada() = links.size() > 2
}
class Chivo inherits Noticia {
  const property montoPagado
  override method criterioCopada() = montoPagado > 2000000
}
class Reportaje inherits Noticia {
  const property entrevistado
  override method criterioCopada() = entrevistado.size().odd()
  override method esSensacionalista() = super() && entrevistado == "Dibu Martínez"
}
class Cobertura inherits Noticia {
  const noticias = []
  override method criterioCopada() = noticias.all{noticia => noticia.esCopada()}
}
//Punto 2
class Periodista {
  const property fechaIngreso
  const  noticiasPublicadas = []

  method esReciente() = fechaIngreso > new Date().minusYears(1)
  method prefiere(noticia)

 //Punto 3
  method puedePublicar(noticia) {
    const noticiasHoy = noticiasPublicadas.filter{ noticia => noticia.fecha()== new Date() }
    const noPreferidasHoy = noticiasHoy.filter{ noticia => !self.prefiere(noticia) }
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

object copado{
  method prefiere(noticia) = noticia.esCopada()
}
object esSensacionalista {
  method prefiere(noticia) = noticia.esSensacionalista()
    /*noticia.titulo().contains("espectacular") || 
    noticia.titulo().contains("increíble") || 
    noticia.titulo().contains("grandioso") ||
    noticia.esPreferidaPorSensacionalista()*/
}
object vago  {
  method prefiere(noticia) = noticia.aptaParaVago()
    //Chivo || noticia.cantidadPalabras() < 100
}
object joseDeZer {
  method prefiere(noticia) = noticia.titulo().startsWith("T")
}

//Punto 4
object multimedio {
  const periodistas = []

  method periodistasRecientesActivos() =
    periodistas.filter({periodista =>
      periodista.esReciente() && periodista.any{noticia => noticia.fecha().daysTo(new Date()) <= 7}
    })
}

//punto 3

object medioDeComunicacion {
  const noticias = []

  method agregarNoticia(noticia) {
    self.validarCantidadDeNoticiasNoPreferidas(noticia)

    noticias.add(noticia)
  }
  method validarCantidadDeNoticiasNoPreferidas(noticia) {
    //if(!noticia.esPreferidoPorAutor( |&& self.limiteDeNoticiasNoPreferidaPara(noticia.autor())))
      throw new DomainException(message = "El autor ha superado el límite de noticias no preferidas")
    }
    method limiteDeNoticiasNoPreferidaPara(autor) = 
      noticias.count{ noticia => !autor.prefiere(noticia) && 
      noticia.autor() == autor  && 
      noticia.esDeLaFecha(new Date())} > 2
  }


