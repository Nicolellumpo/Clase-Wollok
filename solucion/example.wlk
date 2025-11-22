 //EJECICO PRE-PARCIAL - Noticias de ayer , extra
//Punto 1 
class Noticia {
  const property fecha 
  const property importancia // es const para q sea mas mutable
  const property titulo
  const property desarrollo 
  const property autor
 
 //Template Method 
  method esCopada() =
    self.esImportante() &&
    self.esReciente() &&
    self.esCopadaEspecifica() // es la condicion particulat de template method

  method esImportante() = importancia >= 8

  //method esReciente() = fecha > new Date().minusDays(3) // tambein es valido 
  method esReciente() = new Date() - fecha < 3 

  method esCopadaEspecifica() // Primitiva

  
  //method estaBienEscrita() =titulo.size() >= 2 && desarrollo.size() > 0
  //method esPreferidaPorSensacionalista() = false
  method esSensacionalista() = self.titulo().contains (["espectacular" , "increíble" , "grandioso"])

  method tituloContiene(palabras) = palabras.any{ titulo => titulo.contains(palabras) }

  method aptaParaVago() = desarrollo.words().length()<100

  method tituloEmpiezaCon(letra) = titulo.startsWith(letra) //Chequeo para joseDeZer
  
  method esPreferidoPorAutor() = autor.prefiere(self)

  method cantidadDePalabrasEnTitulo() = titulo.words().size()

  method validarTitulo() {
    if (self.cantidadDePalabrasEnTitulo() < 2) 
      throw new DomainException(message = "El título debe tener al menos dos palabras")
  }

  method validarContenido() {
    if (desarrollo.size() == " ") 
      throw new DomainException(message = "El desarrollo no puede estar vacío")
  }

  method validarBienEscrita() {
    self.validarTitulo() 
    self.validarContenido()
  }

  method esNueva() = new Date() - fecha < 6

  method tieneAutorReciente() = autor.esReciente()

}

class NoticiaComun inherits Noticia {
  const links = []
  override method esCopadaEspecifica() = links.size() > 2
}
class Chivo inherits Noticia {
  const property montoPagado
  override method esCopadaEspecifica() = montoPagado > 2000000
  override method aptaParaVago() = true
}
class Reportaje inherits Noticia {
  const property entrevistado
  override method esCopadaEspecifica() = entrevistado.size().odd()
  override method esSensacionalista() = super() && entrevistado == "Dibu Martínez"
}
class Cobertura inherits Noticia {
  const noticias = []
  override method esCopadaEspecifica() = noticias.all{noticia => noticia.esCopada()}
}
//Punto 2
class Periodista {
  const property fechaIngreso
  var property preferencia  

  method esReciente() = new Date() - fechaIngreso < 365
  method prefiere(noticia) = preferencia.prefiere(noticia)
}

object noticiaCopada{
  method prefiere(noticia) = noticia.esCopada()
}
object noticiaSensacionalista {
  method prefiere(noticia) = noticia.esSensacionalista()
}
object vago  {
  method prefiere(noticia) = noticia.aptaParaVago()
}
object joseDeZer {
  method prefiere(noticia) = noticia.tituloEmpiezaCon("T")
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

  method periodistasRecientesPublicaron() = 
    self.noticiasNuevasPeriodistaRecientes().map{noticia => noticia.autor()}.asSet()

  method agregarNoticia(noticia) {
    self.validarCantidadDeNoticiasNoPreferidas(noticia)
    noticia.validarBienEscrita()
    noticias.add(noticia)
  }

  method validarCantidadDeNoticiasNoPreferidas(noticia) {
    if(!noticia.esPreferidoPorAutor() && self.limiteDeNoticiasNoPreferidaPara(noticia.autor()))
      throw new DomainException(message = "El autor ha superado el límite de noticias no preferidas")
    }
    method limiteDeNoticiasNoPreferidaPara(autor) = 
      noticias.count({ noticia => !autor.prefiere(noticia) && 
      noticia.autor() == autor  && 
      noticia.esDeHoy(new Date())}) == 2

  method noticiasNuevasPeriodistaRecientes() = noticias.filter{
    noticia => noticia.esNueva() && noticia.tieneAutorReciente()}
  }

 
    

