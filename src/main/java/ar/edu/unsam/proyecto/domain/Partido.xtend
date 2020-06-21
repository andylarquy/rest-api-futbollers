package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.exceptions.InsufficientCandidates
import ar.edu.unsam.proyecto.exceptions.ObjectAlreadyExists
import ar.edu.unsam.proyecto.repos.RepositorioCancha
import ar.edu.unsam.proyecto.repos.RepositorioEmpresa
import ar.edu.unsam.proyecto.repos.RepositorioEquipo
import ar.edu.unsam.proyecto.repos.RepositorioNotificacion
import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson
import ar.edu.unsam.proyecto.webApi.jsonViews.LocalDateTimeSerializer
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.annotation.JsonView
import com.fasterxml.jackson.databind.annotation.JsonSerialize
import java.time.Duration
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.Period
import java.time.ZoneId
import java.util.Date
import java.util.HashSet
import java.util.Set
import java.util.Timer
import java.util.TimerTask
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
@Entity
@JsonInclude(Include.NON_NULL) //En teoria si un campo es null no lo parsea (<3 gracias Jackson!)
class Partido {

	@JsonView(ViewsPartido.ListView, ViewsNotificacion.NotificacionView)
	@Id
	Long idPartido

	@JsonView(ViewsPartido.ListView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Equipo equipo1

	@JsonView(ViewsPartido.ListView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Equipo equipo2

	@JsonView(ViewsPartido.DefaultView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Empresa empresa

	@JsonView(ViewsPartido.DetallesView, ViewsPartido.ListView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Cancha canchaReservada

	@JsonView(ViewsPartido.DetallesView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Promocion promocion

	@JsonView(ViewsPartido.ListView, ViewsNotificacion.NotificacionView)
	@Column
	Boolean confirmado

	@Column
	Boolean estado = true
	
	@JsonView(ViewsPartido.ListView)
	@Column
	int cantidadDeConfirmaciones = 0
	
	@JsonSerialize(using=LocalDateTimeSerializer)
	@JsonView(ViewsPartido.ListView)
	@Column
	LocalDateTime fechaDeCreacion = LocalDateTime.now().withNano(0).withSecond(0)
	
	@JsonSerialize(using=LocalDateTimeSerializer)
	@Column
	@JsonView(ViewsPartido.DetallesView, ViewsNotificacion.NotificacionView, ViewsPartido.ListView)
	LocalDateTime fechaDeReserva

	@Transient
	transient RepositorioUsuario repoUsuario = RepositorioUsuario.instance

	@Transient
	transient RepositorioNotificacion repoNotificacion = RepositorioNotificacion.instance

	@Transient
	transient RepositorioCancha repoCancha = RepositorioCancha.instance

	@Transient
	transient RepositorioEmpresa repoEmpresa = RepositorioEmpresa.instance

	@Transient
	transient RepositorioPartido repoPartido = RepositorioPartido.instance

	transient static val ID_EQUIPO_TEMPORAL = -2
	transient static val DIAS_PARA_CONFIRMAR = 2
	transient static val DEBUG_SEGUNDOS_PARA_CONFIRMAR = 30
	
	@Transient
	transient AuxiliarDynamicJson auxiliar = new AuxiliarDynamicJson

	new() {
		// ======= [DEBUG] =======
		val fechaDeEliminacionDebug = LocalDateTime.now().plusSeconds(DEBUG_SEGUNDOS_PARA_CONFIRMAR)
		var fechaDeEliminacionDebugAsDate = Date.from(
			fechaDeEliminacionDebug.atZone(ZoneId.systemDefault()).toInstant())

		val fechaDeEliminacion = LocalDateTime.now().plusDays(DIAS_PARA_CONFIRMAR)
		val fechaDeEliminacionAsDate = Date.from(fechaDeEliminacion.atZone(ZoneId.systemDefault()).toInstant())

		// Desde el momento de creacion de un partido hay X dias para confirmarlo y asi evitar su autoeliminacion
		new Timer().schedule(autoEliminarPartido, fechaDeEliminacionAsDate)

		// Para eliminar el warning
		fechaDeEliminacionDebugAsDate = fechaDeEliminacionDebugAsDate
	}

	@Transient
	transient TimerDebugEliminacion debugAutoEliminarPartido = new TimerDebugEliminacion(this)

	@Transient
	transient TimerEliminacion autoEliminarPartido = new TimerEliminacion(this)

	def precioTotal() {
		canchaReservada.precio * (1 - porcentajeDescuento / 100)
	}

	def porcentajeDescuento() {
		promocion !== null ? promocion.porcentajeDescuento : return 0
	}

	def validar() {

		if (fechaDeReserva === null) {
			throw new Exception('El partido debe tener una fecha de reserva')
		}

		equipo1.validar
		equipo2.validar
		empresa.validar
		canchaReservada.validar
		repoPartido.validarFechaCancha(fechaDeReserva, canchaReservada)
	}
	
	//TODO: Pensar bien estas validaciones
	def validarCreacion() {
		empresa.validar
		canchaReservada.validar
		repoPartido.validarFechaCancha(fechaDeReserva, canchaReservada)
	}
	
	def validarPersistir() {
		empresa.validar
		canchaReservada.validar
		repoPartido.validarFechaCancha(fechaDeReserva, canchaReservada)
	}

	// TODO: Separar en equipo y equipo completo
	def participaUsuario(Usuario usuario) {
		equipo1.participaUsuario(usuario) || equipo2.participaUsuario(usuario)
	}

	def validarFechaEstaLibre(LocalDateTime fecha, Cancha cancha) {
		if (sonLaMismaFecha(fechaDeReserva.toLocalDate, fecha.toLocalDate) &&
			laDiferenciaEsMenorAUnaHora(fechaDeReserva, fecha) &&
			canchaReservada.idCancha == cancha.idCancha) {
			throw new ObjectAlreadyExists('Ya existe una reserva para esa fecha y hora')
		}
	}

	def sonLaMismaFecha(LocalDate fecha1, LocalDate fecha2) {
		Period.between(fecha1, fecha2).days == 0
	}

	def laDiferenciaEsMenorAUnaHora(LocalDateTime fecha1, LocalDateTime fecha2) {
		Math.abs(Duration.between(fecha1, fecha2).toMinutes) < 60
	}

	def tieneEquipoTemporal() {
		return equipo1.idEquipo < 0 || equipo2.idEquipo < 0
	}

	def jugadoresTemporalesDelPartido() {
		val jugadores = jugadoresDelPartido
		return jugadores.filter[jugador|jugador.esIntegranteDesconocido].toSet
	}

	def jugadoresDelPartido() {
		val jugadores = new HashSet()
		jugadores.addAll(equipo1.integrantes)
		jugadores.addAll(equipo2.integrantes)

		return jugadores
	}

	def getJugadoresConocidos() {
		val conocidosEquipo1 = equipo1.integrantes.filter[esIntegranteConocido]
		val conocidosEquipo2 = equipo2.integrantes.filter[esIntegranteConocido]
		val jugadoresConocidos = new HashSet()
		jugadoresConocidos.addAll(conocidosEquipo1)
		jugadoresConocidos.addAll(conocidosEquipo2)
		return jugadoresConocidos
	}

	def mapearJugadoresConocidos() {
		equipo1.mapearJugadoresConocidos
		equipo2.mapearJugadoresConocidos 
	}

	def eliminarJugadoresTemporales() {
		equipo1.integrantes.removeIf[integrante|integrante.esIntegranteDesconocido]
		equipo2.integrantes.removeIf[integrante|integrante.esIntegranteDesconocido]
	}

	def prepararParaPersistir() {
		
		confirmado = false
		eliminarJugadoresConocidos()
		mapearJugadoresTemporales()
		asignarNombreEquipos()
		asignarIdEquiposTemporales()
		mapearEquipo(equipo1)
		mapearEquipo(equipo2)
	}
	
	def mapearJugadoresTemporales() {
		equipo1.mapearJugadoresTemporales
		equipo2.mapearJugadoresTemporales
	}
	
	def eliminarJugadoresConocidos(){
		
		if(equipo1.idEquipo != ID_EQUIPO_TEMPORAL ){
			equipo1.eliminarJugadoresConocidos	
		}
		
		if(equipo2.idEquipo != ID_EQUIPO_TEMPORAL){
			equipo2.eliminarJugadoresConocidos
		}
		
		
	}

	def asignarNombreEquipos() {
		equipo1.asignarNombreTemporal
		equipo2.asignarNombreTemporal
	}

	def asignarIdEquiposTemporales() {
		equipo1.asignarIdEquipoTemporal
		equipo2.asignarIdEquipoTemporal
	}

	def mapearEquipo(Equipo equipo) {

		val equipoAPrestitr = new Equipo()

		if (equipo.idEquipo === null) {
			equipoAPrestitr.idEquipo = equipo.idEquipo
		}

		equipoAPrestitr.nombre = equipo.nombre
		equipoAPrestitr.foto = equipo.foto
		equipoAPrestitr.owner = equipo.owner
	}

	def mapearCancha() {
		val canchaPosta = repoCancha.searchById(canchaReservada.idCancha)
		canchaPosta === null ? throw new Exception('El ID de la cancha no es valido')
		canchaReservada = canchaPosta
	}

	def mapearEmpresa() {
		val empresaPosta = repoEmpresa.searchById(empresa.idEmpresa)
		empresaPosta === null ? throw new Exception('El ID de la empresa no es valido')
		empresa = empresaPosta
	}

	def confirmarPartido() {
		confirmado = true
		repoPartido.update(this)
	}
	
	def jugadoresDesconocidos() {
		val jugadoresDesconocidos = new HashSet()
		if (this.tieneEquipoTemporal) {
			jugadoresTemporalesDelPartido.forEach[jugador|
				buscarCandidatoPorGPS(jugador, equipo1.owner).forEach[this.agregarUsuarioSiNoEsta(jugadoresDesconocidos, it)]
			]
		}
		
		if(jugadoresDesconocidos.size < jugadoresTemporalesDelPartido.size){
			throw new InsufficientCandidates('No se han encontrado suficentes jugadores para cubrir los puestos con esos parametros de busqueda')
		}
		
		return jugadoresDesconocidos
	}
	
	def buscarCandidatoPorGPS(Usuario usuarioABuscar, Usuario usuarioOwner) {
		val int rangoDeBusqueda = Integer.parseInt(usuarioABuscar.email)
		val sexoBuscado = usuarioABuscar.sexo
		val posicionBuscada = usuarioABuscar.posicion

		repoUsuario.getUsuariosEnElRangoDe(usuarioOwner, rangoDeBusqueda, sexoBuscado, posicionBuscada).toSet
	}
	
	def agregarUsuarioSiNoEsta(Set<Usuario> coleccion, Usuario usuario){
		if(!coleccion.exists[jugador | jugador.idUsuario == usuario.idUsuario]){
			coleccion.add(usuario)
		}
	}
	
	
	def enviarNotifiacionesAConocidos(Set<Usuario> destinatarios, Usuario owner) {
		
		val invitacion = new Notificacion()
		invitacion.partido = this
		invitacion.titulo = "¡ "+owner.nombre+" te invito a un partido!"
		invitacion.descripcion = invitacion.partido.empresa.direccion + " - " +
			auxiliar.dateTransformer(invitacion.partido.fechaDeReserva)

		repoNotificacion.enviarMultipleNotificacion(invitacion, destinatarios)
	}
	
	def enviarNotifiacionesADesconocidos(Set<Usuario> destinatarios) {
		val invitacion = new Notificacion()
		invitacion.partido = this
		invitacion.titulo = "¡Has recibido una invitacion para un partido!"
		invitacion.descripcion = invitacion.partido.empresa.direccion + " - " +
			auxiliar.dateTransformer(invitacion.partido.fechaDeReserva)
		repoNotificacion.enviarMultipleNotificacion(invitacion, destinatarios)
	}
	
	def agregarPuesto(Usuario usuario) {
		
		if(equipo1.tienePuestoLibrePara(usuario)){
			equipo1.agregarIntegranteAPuesto(usuario)
		}else if (equipo2.tienePuestoLibrePara(usuario)){
			equipo2.agregarIntegranteAPuesto(usuario)
		}else{
			throw new Exception('No hay hueco en el partido para este jugador')
		}
	}
	
	def faltanJugadores() {
		cantidadDeConfirmaciones + 1 < canchaReservada.cantidadJugadores
	}
	
	//Valida que la fecha de reserva sea minimo dos dias despues que la de creacion
	//TODO: No estoy seguro de si hace falta el valor absoluto, pero mejor prevenir
	def validarDiasDeConfirmacionFechaDeReserva() {
		
		if(Math.abs(Period.between(fechaDeReserva.toLocalDate, fechaDeCreacion.toLocalDate).days) < DIAS_PARA_CONFIRMAR){
			throw new Exception('Debes reservar con una antelacion de minimo '+DIAS_PARA_CONFIRMAR+' dias')
		}
		
	}
	
	def eliminarJugadoresReservados(){
		equipo1.desvincularJugadoresReservados
		equipo2.desvincularJugadoresReservados
	}

	
}

//TimerTask Auxiliar
class TimerEliminacion extends TimerTask {

	Partido partido
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance

	new(Partido partido_) {
		partido = partido_
	}

	override run() {

		// Volvemos a ir al back para traer el estado de confirmacion 2 dias despues
		partido = RepositorioPartido.instance.searchById(partido.idPartido)

		if (!partido.confirmado) {
			println("[INFO]: Se va ha realizar la baja logica del partido sin confirmar con ID: " + partido.idPartido)
			RepositorioPartido.instance.eliminarPartido(partido)
			
			partido.equipo1 = repoEquipo.searchByIdConIntegrantes(partido.equipo1.idEquipo)
			partido.equipo2 = repoEquipo.searchByIdConIntegrantes(partido.equipo2.idEquipo)
		
			partido.eliminarJugadoresReservados()
		}
	}

}

class TimerDebugEliminacion extends TimerTask {

	Partido partido
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance

	new(Partido partido_) {
		partido = partido_
	}

	override run() {

		// Volvemos a ir al back para traer el estado de confirmacion 2 dias despues
		partido = RepositorioPartido.instance.searchById(partido.idPartido)
		
		if (!partido.confirmado) {
			println("[INFO]: Se va ha realizar la baja logica del partido sin confirmar con ID: " + partido.idPartido)
			RepositorioPartido.instance.eliminarPartido(partido)
			
			partido.equipo1 = repoEquipo.searchByIdConIntegrantes(partido.equipo1.idEquipo)
			partido.equipo2 = repoEquipo.searchByIdConIntegrantes(partido.equipo2.idEquipo)
			
			partido.eliminarJugadoresReservados()
		}
	}

}
