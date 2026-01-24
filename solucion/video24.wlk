// Practica  Plataformas de pago

object publicidad{
    method recaudacionDe(contenido) =  (
        contenido.vistas() * 0.05 +
        if (contenido.esPopular()) 200 else 0 ) . min(contenido.recadacionMaximaParaPublicidad())
    method puedeAplicarse(contenido) = !contenido.ofensivo()
}
class Donaciones{
    var property donaciones
    method recaudacionDe(contenido) = donaciones
    method puedeAplicarse(contenido) = true

}
class VentaDeDescarga{
    const property precio
    method recaudacionDe(contenido) = contenido.vistas() * precio
    method puedeAplicarse(contenido) = contenido.puedeVenderse()
}
class Alquiler inherits VentaDeDescarga {
    override method precio() = 1.max(super())
    override method puedeAplicarse(contenido) = super(contenido) && contenido.puedeAquilarse()
}

class Contenido{
    const property titulo
    const property ofensivo = false
    var property vistas
    var property monetizacion 
    
    method monetizacion(nuevaMonetizacion){
        if (!nuevaMonetizacion.puedeAplicarse(self))
            throw new DomainException(message = "El contenido no soporta la monetizacion seleccionada")
        monetizacion = nuevaMonetizacion
    }
    method initialize(){
        if(!monetizacion.puedeAplicarse(self))
            throw new DomainException(message = "El contenido no soporta la monetizacion seleccionada")
    }
    method esPopular()
    method puedeVenderse() = self.esPopular()
    method puedeAquilarse()
    method recaudar() = monetizacion.recaudacionDe(self)
    method recadacionMaximaParaPublicidad()
   
}
class Videos inherits Contenido {

    override method esPopular() = vistas > 1000
    override method recadacionMaximaParaPublicidad()= 10000
    override method puedeAquilarse() = true
}
class Imagenes inherits Contenido {
    var property tags = []
    const property tagsDeModa = ["meme","cute","funny","art","nature"]
    
    override method esPopular() = tagsDeModa.all{tag => tags.contains(tag)}
    override method recadacionMaximaParaPublicidad()= 4000
    override method puedeAquilarse() = false
}
object usuarios{
    var property todosLosUsuarios = []

    method emailsDeLosUsuariosRicos() = todosLosUsuarios
        .filter{usuario => usuario.verificado()}
        .sortedBy{uno , otro => uno. saldoTotal() > otro.saldoTotal()}
        .take(100)
        .map{usuario => usuario.email()}
    method cantidadDeUsuarios() = todosLosUsuarios.count{usuario => usuario.esSuperUsuario()}
}
class Usuario{
    const property nombre
    const property email
    var property verificarUsuario = false 
    var property contenidos = []

    method saldoTotal() = contenidos.sum{contenido => contenido.recaudar()}
    method esSuperUsuario() = contenidos.count{contenido => contenido.esPopular()} >= 10
    method publicar(contenido){
        contenidos.add(contenido)
    }   
}