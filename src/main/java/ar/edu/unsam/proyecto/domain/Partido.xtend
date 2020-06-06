package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.exceptions.InsufficientCandidates
import ar.edu.unsam.proyecto.exceptions.ObjectAlreadyExists
import ar.edu.unsam.proyecto.repos.RepositorioCancha
import ar.edu.unsam.proyecto.repos.RepositorioEmpresa
import ar.edu.unsam.proyecto.repos.RepositorioNotificacion
import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
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
import java.util.Timer
import java.util.TimerTask
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
@JsonInclude(Include.NON_NULL) //En teoria si un campo es null no lo parsea (<3 gracias Jackson!)
class Partido {

	@JsonView(ViewsPartido.ListView)
	@Id @GeneratedValue
	Long idPartido

//TODO - En principio parece que no hace falta pero lo dejamos por las dudas
//	@JsonView(ViewsPartido.DefaultView)
//	transient Usuario owner
	@JsonView(ViewsPartido.ListView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Equipo equipo1

	@JsonView(ViewsPartido.ListView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Equipo equipo2

	@JsonView(ViewsPartido.DefaultView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Empresa empresa

	@JsonView(ViewsPartido.DetallesView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Cancha canchaReservada

	@JsonSerialize(using = LocalDateTimeSerializer)
	@Column()
	@JsonView(ViewsPartido.DetallesView, ViewsNotificacion.NotificacionView, ViewsPartido.ListView)
	LocalDateTime fechaDeReserva

	@JsonView(ViewsPartido.DetallesView, ViewsNotificacion.NotificacionView)
	@ManyToOne
	Promocion promocion

	@JsonView(ViewsPartido.ListView, ViewsNotificacion.NotificacionView)
	@Column
	Boolean confirmado = false

	@Column
	Boolean estado = true

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

	new() {
		// ======= [DEBUG] =======
		val fechaDeEliminacionDebug = LocalDateTime.now().plusSeconds(DEBUG_SEGUNDOS_PARA_CONFIRMAR)
		var fechaDeEliminacionDebugAsDate = Date.from(
			fechaDeEliminacionDebug.atZone(ZoneId.systemDefault()).toInstant())
		
		val fechaDeEliminacion = LocalDateTime.now().plusDays(DIAS_PARA_CONFIRMAR)
		val fechaDeEliminacionAsDate = Date.from(fechaDeEliminacion.atZone(ZoneId.systemDefault()).toInstant())

		// Desde el momento de creacion de un partido hay X dias para confirmarlo y asi evitar su autoeliminacion
		new Timer().schedule(autoEliminarPartido, fechaDeEliminacionAsDate);
	
		//Para eliminar el warning
		fechaDeEliminacionDebugAsDate = fechaDeEliminacionDebugAsDate
	}

	@Transient
	transient TimerDebugEliminacion debugEliminacion = new TimerDebugEliminacion()

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
	}

	// TODO: Separar en equipo y equipo completo
	def participaUsuario(Usuario usuario) {
		equipo1.participaUsuario(usuario) || equipo2.participaUsuario(usuario)
	}

	def validarFechaEstaLibre(LocalDateTime fecha) {
		if (sonLaMismaFecha(fechaDeReserva.toLocalDate, fecha.toLocalDate) &&
			laDiferenciaEsMenorAUnaHora(fechaDeReserva, fecha)) {
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
		return equipo1.idEquipo == ID_EQUIPO_TEMPORAL || equipo2.idEquipo == ID_EQUIPO_TEMPORAL
	}

	def mapearJugadoresTemporales() {

		if (this.tieneEquipoTemporal) {
			jugadoresTemporalesDelPartido.forEach[jugador|buscarJugadorPorGPS(jugador, equipo1.owner)]
		}
	}

	def void buscarJugadorPorGPS(Usuario usuarioABuscar, Usuario usuarioOwner) {
		val int rangoDeBusqueda = Integer.parseInt(usuarioABuscar.email)
		val sexoBuscado = usuarioABuscar.sexo
		val posicionBuscada = usuarioABuscar.posicion

		val candidatos = repoUsuario.getUsuariosEnElRangoDe(usuarioOwner, rangoDeBusqueda, sexoBuscado, posicionBuscada)

		if (candidatos.size >= jugadoresTemporalesDelPartido.size) {

			candidatos.forEach [ candidato |
				val invitacion = new Notificacion()
				invitacion.partido = this
				invitacion.usuario = candidato
				invitacion.descripcion = "¡Has recibido una invitación para un partido en " +
					invitacion.partido.empresa.direccion + " el día " + invitacion.partido.fechaDeReserva +
					"! (TODO: Formatear bien la fecha)"

				repoNotificacion.agregarNotificacion(invitacion)
			]

		} else {
			throw new InsufficientCandidates(
				"No se han encontrado suficientes jugadores con esos parametros de busqueda")
		}

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

	def void jugadoresConocidos() {}

	def mapearJugadoresConocidos() {
		equipo1.mapearJugadoresConocidos
		equipo2.mapearJugadoresConocidos
	}

	def eliminarJugadoresTemporales() {
		equipo1.integrantes.removeIf[integrante|integrante.esIntegranteDesconocido]
		equipo2.integrantes.removeIf[integrante|integrante.esIntegranteDesconocido]
	}

	def prepararParaPersistir() {
		eliminarJugadoresTemporales()
		asignarNombreEquipos()
		asignarIdEquiposTemporales()
		mapearEquipo(equipo1)
		mapearEquipo(equipo2)
		mapearCancha()
	}

	def asignarNombreEquipos() {
		equipo1.asignarNombreTemporal
		equipo2.asignarNombreTemporal
	}

	def asignarIdEquiposTemporales() {
		equipo1.asignarIdEquipoTemporal
		equipo2.asignarIdEquipoTemporal
	}

	def mapearEquipo(Equipo equipo){
	
		val equipoAPrestitr = new Equipo()
	
		if(equipo.idEquipo === null){
			equipoAPrestitr.idEquipo = equipo.idEquipo
		}
	
		equipoAPrestitr.nombre = equipo.nombre
		equipoAPrestitr.foto = equipo.foto
		equipoAPrestitr.owner = equipo.owner
		equipoAPrestitr.integrantes = equipo.integrantes
	
	}

	def mapearCancha() {
		canchaReservada = repoCancha.searchById(canchaReservada.idCancha)
	}

	def mapearEmpresa() {
		empresa = repoEmpresa.searchById(empresa.idEmpresa)
	}

	def confirmarPartido() {
		confirmado = true
		repoPartido.update(this)
	}

	
}

//TimerTask Auxiliar
class TimerEliminacion extends TimerTask {

	Partido partido

	new(Partido partido_) {
		partido = partido_
	}

	override run() {

		// Volvemos a ir al back para traer el estado de confirmacion 3 dias despues
		partido = RepositorioPartido.instance.searchById(partido.idPartido)

		if (!partido.confirmado) {
			println("[INFO]: Se va ha realizar la baja logica del partido sin confirmar con ID: " + partido.idPartido)
			RepositorioPartido.instance.eliminarPartido(partido)
		}
	}

}

class TimerDebugEliminacion extends TimerTask {

	override run() {
		println("TIMER: RIIING!")
	}

}
