package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.repos.RepositorioEquipo
import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.annotation.JsonView
import java.util.ArrayList
import java.util.HashSet
import java.util.Set
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToMany
import javax.persistence.ManyToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unsam.proyecto.repos.RepositorioNotificacion

@Accessors
@Entity
@JsonInclude(Include.NON_NULL)
class Equipo {
	
	@JsonView(ViewsEquipo.ListView, ViewsNotificacion.NotificacionView, ViewsPartido.DefaultView)
	@Id @GeneratedValue  
	Long idEquipo
	
	@Column
	@JsonView(ViewsEquipo.ListView, ViewsPartido.ListView) 
	String nombre
	
	@Column
	@JsonView(ViewsEquipo.ListView) 
	String foto
	
	@Column
	@JsonView(ViewsEquipo.DefaultView, ViewsNotificacion.NotificacionView, ViewsPartido.DefaultView)
	Boolean estado = true
	
	@ManyToOne
	@JsonView(ViewsEquipo.ListView, ViewsPartido.ListView) 
	Usuario owner
	
	@ManyToMany
	@JsonView(ViewsEquipo.ListView, ViewsPartido.ListView) 
	Set<Usuario> integrantes
	
	@Transient
	transient RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	
	@Transient
	transient RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	
	@Transient
	transient RepositorioPartido repoPartido = RepositorioPartido.instance
	
	@Transient
	transient RepositorioNotificacion repoNotificaciones = RepositorioNotificacion.instance
	
	def agregarIntegrante(Usuario integrante){
		integrantes.add(integrante)
	}
	
	def quitarIntegrante(Usuario integrante){
		if(this.esOwner(integrante)){
			throw new Exception('El administrador no puede abandonar el equipo')
		}else{		
			integrantes.remove(integrante)
		}
	}
	
		
	def quitarIntegranteById(Long idBuscado) {
		if(this.esOwner(idBuscado)){
			throw new Exception('El administrador no puede abandonar el equipo')
		}else{			
			integrantes.removeIf[it.idUsuario == idBuscado]
		}
	}
	
	
	def validar(){
		
		if (nombre === null){
			throw new Exception('El equipo debe tener un nombre')
		}
		
		if (foto === null){
			throw new Exception('El equipo debe tener una foto')
		}
		
		if (owner  === null){
			throw new Exception('El equipo debe tener un dueño')
		}
		
		owner.validar
		
		if (integrantes === null){
			throw new Exception('El equipo debe tener una lista de integrantes')
		}
		
	}
	
	def participaUsuario(Usuario usuario){
		esOwner(usuario) || integrantes.exists[integrante | integrante.idUsuario.equals(usuario.idUsuario)]
	}
	
	def participaUsuarioById(Long idBuscado){
		idDeIntegrantes.contains(idBuscado)
	}
	
	def esOwner(Usuario usuario){
		usuario.idUsuario == owner.idUsuario
	}
	
	def esOwner(Long idBuscado){
		idBuscado == owner.idUsuario
	}
	
	def idDeIntegrantes() {
		integrantes.map[idUsuario].toList
	}
	
	def getUsuariosTemporales() {
		integrantes.filter[it.esIntegranteDesconocido]
	}
	
	def mapearJugadoresConocidos() {
		
		if(esEquipoConocido){

			val integrantesConocidos = new HashSet()
			integrantesConocidos.addAll(integrantes.filter[esIntegranteConocido])
			integrantes.removeAll(integrantesConocidos)
			integrantesConocidos.forEach[usuario | integrantes.add(repoUsuario.searchByIdConAmigos(usuario.idUsuario))]
		
		}
		
		owner = repoUsuario.searchByIdConAmigos(owner.idUsuario)
	}
	
	def esEquipoConocido(){
		idEquipo > -1
	}
	
	def asignarNombreTemporal(){
		if(idEquipo < 0){
			nombre = "Equipo Temporal"
		}
	}
	
	def getAsignarIdEquipoTemporal() {
		if(idEquipo < 0){
			//Es null a proposito
			idEquipo = null
		}
	}
	
	def validarEstaVacio() {
		integrantes.size > 0 ? throw new Exception("Server Error: El equipo no debe tener integrantes para persistir en la base")
	}
	
	def getEliminarJugadores() {
		integrantes = new HashSet
	}
	
	def getIntegrantesConocidos(){
		integrantes.filter[it.esIntegranteConocido]
	}
	
	def mapearJugadoresTemporales() {
		
		val integrantesMapeados = new HashSet
		
		integrantes.forEach[jugador | 
			if(jugador.idUsuario < 0){
				
				val nuevoUsuario = new Usuario()
				nuevoUsuario.nombre = "RESERVA JUGADOR"
				nuevoUsuario.posicion = jugador.posicion
				nuevoUsuario.sexo = jugador.sexo
				
				repoUsuario.crearUsuarioTemporal(nuevoUsuario)
				integrantesMapeados.add(nuevoUsuario)
			}
		]
		
		this.eliminarIntegrantesDesconocidos
		integrantes.addAll(integrantesMapeados)
	}
	
	def eliminarJugadoresConocidos() {
		integrantes.removeIf[esIntegranteConocido]
	}
	
	def eliminarIntegrantesDesconocidos(){
		integrantes.removeIf[!esIntegranteConocido]
	}
	
	def tienePuestoLibrePara(Usuario usuario){
		
		integrantes.exists[ jugador |
			jugador.esJugadorReservado() && jugador.jugadorReservadoAdmite(usuario)
		]
	}
	
	def agregarIntegranteAPuesto(Usuario usuario) {
		val jugadorReservado = integrantes.findFirst[jugador | jugador.jugadorReservadoAdmite(usuario)]
		
		integrantes.remove(jugadorReservado)
		repoEquipo.update(this)
		
		integrantes.add(usuario)
		repoEquipo.update(this)
		
		try{
			repoUsuario.delete(jugadorReservado)
		}catch(RuntimeException e){	
			//Existe un caso excepcional que no sabemos reproducir en el que sucede un error al realizar 
			//este delete. Imprimimos la excepcion para que si nos lo encontramos alguna vez podamos resolverlo
			Thread.dumpStack()
			val excepcionRara = new Exception('Hubo un error al procesar la invitacion')
			excepcionRara.printStackTrace
			throw excepcionRara
		}
		
	}
	
	def validarCreacion() {
		if (nombre === null){
			throw new Exception('El equipo debe tener un nombre')
		}
		
		if (foto === null){
			throw new Exception('El equipo debe tener una foto')
		}
		
		if (owner  === null){
			throw new Exception('El equipo debe tener un dueño')
		}
		
		owner.validarCreacion
		
		if (integrantes === null){
			throw new Exception('El equipo debe tener una lista de integrantes')
		}
		
	}
	
	def tieneNombre(String nombreBuscado) {
		nombre.toLowerCase.equals(nombreBuscado)
	}
	
	def eliminarJugadoresReservados() {
		integrantes.forEach[ jugador |
			if(jugador.esJugadorReservado){
				repoUsuario.delete(jugador)
			}
		]
	}
	
	def desvincularJugadoresReservados() {
		
		val integrantesReservados = new ArrayList
		integrantesReservados.addAll(integrantes.filter[esJugadorReservado])
		
		//No hago removeAll xq desconfio
		integrantesReservados.forEach[ jugador |
			integrantes.remove(jugador)
		]
		
		repoEquipo.update(this)
		
		integrantesReservados.forEach[ jugador |
			repoUsuario.delete(jugador)
		]
		
	}
	
	//	Estos dos metodos se pueden juntar, pero hicimos tantas acrobacias
	// con el codigo que me da miedo tocarlo
	def tienePartidosPendientes() {
		repoPartido.coleccion.exists[it.participaEquipo(this)]
	}
	
	def partidosPendientes(){
		repoPartido.coleccionConIntegrantes.filter[it.participaEquipo(this)]
	}
	
	def tieneId(Long idBuscado) {
		this.idEquipo == idBuscado
	}
	
	//Aclaracion: Cuando rechazas una invitacion la notificacion se elimina del sistema
	// Y cuando aceptas una invitacion se guarda en el sistema
	// Por lo tanto si el usuario tiene invitaciones para partidos que todavia no se han jugado
	// Es que no se decidio a jugarlo o que lo acepto, en cuyo caso no puede abandonar el equipo
	def tienePartidosPendientesConUsuario(Usuario usuario) {
		
		repoNotificaciones.getTodasLasNotificacionesDelUsuario(usuario.idUsuario).exists[ noti |
			noti.partido.participaEquipo(this) &&
			noti.partido.todaviaNoSeJugo()
		]
	}
	
	

}