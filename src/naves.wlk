//archivo naves

class Nave{
    var velocidad= 0
    var direccion= 0
    var combustible=0

    method velocidad()= velocidad

    method acelerar(cuanto){
        velocidad= 100000.min(velocidad + cuanto)
    }
    method desacelerar(cuanto){
        velocidad= 0.max(velocidad - cuanto)
    }

    method irHaciaElSol(){ direccion = 10}
    method escaparDelSol(){ direccion = -10}
    method ponerceParaleloAlSol(){ direccion = 0}

    method acercarseUnPocoAlSol() { direccion= 10.min(direccion+1)}
    method alejarseUnPocoDelSol() { direccion= -10.max(direccion-1)}

    method cargarCombustible(litros){
        combustible= combustible+ litros
    }
    method descargarCombustible(litros){
        combustible= 0.max(combustible- litros)
    }
    method prepararViaje(){
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }

    method estaTranquila(){
        return combustible >= 4000 and velocidad <= 12000 and 
                self.adicionalTranquilidad()
    }
    //metodo abstracto
    method adicionalTranquilidad()
    
    method recibirAmenaza() {self.escapar() self.avisar()}
    method escapar()
    method avisar()
    
    method estaDeRelajo()= self.estaTranquila() and self.tienePocaActividad()
    
    method tienePocaActividad()
}

class NaveBaliza inherits Nave{
    var colorBaliza="verde"
    var cambioDeColor= false

    method colorBaliza()= colorBaliza
    method cambiarColorBaliza(colorNuevo){
        colorBaliza= colorNuevo
        cambioDeColor= true
    }
    override method prepararViaje(){
        super()
        self.cambiarColorBaliza("verde")
        self.ponerceParaleloAlSol()
    }
    override method adicionalTranquilidad(){
        return colorBaliza!= "rojo"
    }
    
    override method escapar() {
    	self.irHaciaElSol()
    }
    override method avisar() {
    	self.cambiarColorBaliza("rojo")
    }
    
    override method tienePocaActividad(){
    	return not cambioDeColor
    }
}

class NaveDePasajeros inherits Nave{
    const cantidadDePasejeros
    var racionesComida= 0
    var racionesBebida= 0

    method cargarComida(raciones){
        racionesComida= racionesComida+ raciones
    }
    method cargarBebida(raciones){
        racionesBebida= racionesBebida+ raciones
    }
    method descargarComida(raciones){
        racionesComida= 0.max(racionesComida- raciones)
    }
    method descargarBebida(raciones){
        racionesBebida= 0.max(racionesBebida- raciones)
    }
    override method prepararViaje(){
        super()
        self.cargarComida(cantidadDePasejeros*4)
        self.cargarBebida(cantidadDePasejeros*6)
        self.acercarseUnPocoAlSol()
    }
    override method adicionalTranquilidad(){ return true }
    
    override method escapar() {
    	self.acelerar(velocidad)
    }
    override method avisar() {
    	self.descargarComida(cantidadDePasejeros)
    	self.descargarBebida(cantidadDePasejeros * 2)
    }
    
    override method tienePocaActividad(){
    	return racionesComida < 50
    }
}

class NaveDeCombate inherits Nave{
    var estaVisible= true
    var misilesDesplegados= false
    const mensajes= []

    method ponerseVisible() { estaVisible= true }
    method ponerseInvisible() { estaVisible= false }
    method estaInvisible()= not estaVisible

    method desplegarMisiles(){
        misilesDesplegados= true
    }
    method replegarMisiles(){
        misilesDesplegados= false
    }
    method misilesDesplegados()= misilesDesplegados
    
    method emitirMensaje(mensaje){mensajes.add(mensaje)}
    method mensajesEmitidos()= mensajes

    method primerMensaje()= mensajes.first()
    method ultimoMensaje()= mensajes.last()
    method esEscueta()= not mensajes.any({mens=> mens.size() > 30})

    method emitioMensaje(mensaje)= mensajes.contains(mensaje)

    override method prepararViaje(){
        super()
        self.ponerseVisible()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("saliendo en mision")
    }
    override method adicionalTranquilidad(){
        return not self.misilesDesplegados()
    }
    
     override method escapar() {
    	self.acercarseUnPocoAlSol()
     	self.acercarseUnPocoAlSol()
    }
    override method avisar() {
    	self.emitirMensaje("Amenaza recibida")
    }
     
     override method tienePocaActividad(){
    	return self.esEscueta()
    }
}

class NaveHospital inherits NaveDePasajeros{
    var quirofanosPreparados= false
    method prepararQuirofanos(){
        quirofanosPreparados= true
    }
    method noPrepararQuirofanos(){
        quirofanosPreparados= false
    }
    method quirofanosPreparados()= quirofanosPreparados

    override method adicionalTranquilidad(){
        return not quirofanosPreparados
    }
    
    override method recibirAmenaza(){
    	super()
    	self.prepararQuirofanos()
    }

}

class NaveDeCombateSigilosa inherits NaveDeCombate {
    override method adicionalTranquilidad(){
        return super() and not self.estaInvisible()
    }
    
     override method recibirAmenaza(){
    	super()
    	self.desplegarMisiles()
    	self.ponerseInvisible()
    }
}

