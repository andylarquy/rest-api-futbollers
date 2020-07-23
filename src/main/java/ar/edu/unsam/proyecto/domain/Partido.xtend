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
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEncuesta
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
import java.util.ArrayList
import java.util.HashSet
import java.util.Set
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
@JsonInclude(Include.NON_NULL)
class Partido {

	@JsonView(ViewsPartido.ListView, ViewsNotificacion.NotificacionView, ViewsEncuesta.DefaultView)
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
	transient static val HORAS_DE_ESPERA_PARA_LA_ENCUESTA = 2
	
	@Transient
	transient AuxiliarDynamicJson auxiliar = new AuxiliarDynamicJson
	
	@Transient
	transient LocalDateTime fechaDeEnvioEncuestas = LocalDateTime.now

	@Transient
	transient EnviarEncuesta enviarEncuestas = new EnviarEncuesta(this)

	@Transient
	transient EliminarPartido eliminarPartido = new EliminarPartido(this)

	def precioTotal() {
		canchaReservada.precio * (1 - porcentajeDescuento / 100)
	}

	def porcentajeDescuento() {
		promocion !== null ? promocion.porcentajeDescuento : return 0
	}

	def owner() {
		equipo1.owner
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
			laDiferenciaEsMenorAUnaHora(fechaDeReserva, fecha) && canchaReservada.idCancha == cancha.idCancha) {
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

	def eliminarJugadoresConocidos() {

		if (equipo1.idEquipo != ID_EQUIPO_TEMPORAL) {
			equipo1.eliminarJugadoresConocidos
		}

		if (equipo2.idEquipo != ID_EQUIPO_TEMPORAL) {
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
		val Set<Usuario> jugadoresDesconocidos = new HashSet()
		if (this.tieneEquipoTemporal) {
			jugadoresTemporalesDelPartido.forEach [ jugador |
				buscarCandidatoPorGPS(jugador, equipo1.owner).forEach [
					this.agregarUsuarioSiNoEsta(jugadoresDesconocidos, it)
				]
			]
		}

		if (jugadoresDesconocidos.size < jugadoresTemporalesDelPartido.size) {
			throw new InsufficientCandidates(
				'No se han encontrado suficentes jugadores para cubrir los puestos con esos parametros de busqueda')
		}

		return jugadoresDesconocidos
	}

	def buscarCandidatoPorGPS(Usuario usuarioABuscar, Usuario usuarioOwner) {

		val int rangoDeBusqueda = Integer.parseInt(usuarioABuscar.email)
		val sexoBuscado = usuarioABuscar.sexo
		val posicionBuscada = usuarioABuscar.posicion

		repoUsuario.getUsuariosEnElRangoDe(usuarioOwner, rangoDeBusqueda, sexoBuscado, posicionBuscada).toSet
	}

	def agregarUsuarioSiNoEsta(Set<Usuario> coleccion, Usuario usuario) {
		if (!coleccion.exists[jugador|jugador.idUsuario == usuario.idUsuario]) {
			coleccion.add(usuario)
		}
	}

	def enviarNotifiacionesAConocidos(Set<Usuario> destinatarios, Usuario owner) {

		val invitacion = new Notificacion()
		invitacion.partido = this
		invitacion.titulo = "¡ " + owner.nombre + " te invito a un partido!"
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

		if (equipo1.tienePuestoLibrePara(usuario)) {
			equipo1.agregarIntegranteAPuesto(usuario)
		} else if (equipo2.tienePuestoLibrePara(usuario)) {
			equipo2.agregarIntegranteAPuesto(usuario)
		} else {
			throw new Exception('No hay hueco en el partido para este jugador')
		}
	}

	def faltanJugadores() {
		cantidadDeConfirmaciones + 1 < canchaReservada.cantidadJugadores
	}

	// Valida que la fecha de reserva sea minimo dos dias despues que la de creacion
	// No estoy seguro de si hace falta el valor absoluto, pero mejor prevenir
	def validarDiasDeConfirmacionFechaDeReserva() {

		if (Math.abs(Period.between(fechaDeReserva.toLocalDate, fechaDeCreacion.toLocalDate).days) <
			DIAS_PARA_CONFIRMAR) {
			throw new Exception('Debes reservar con una antelacion de minimo ' + DIAS_PARA_CONFIRMAR + ' dias')
		}

	}

	def eliminarJugadoresReservados() {
		equipo1.desvincularJugadoresReservados
		equipo2.desvincularJugadoresReservados
	}

	def getJugadoresDeLaEncuesta() {
		val owner = equipo1.owner
		val jugadoresDeLaEncuesta = new ArrayList

		jugadoresDeLaEncuesta.addAll(equipo1.integrantes.filter[!esAmigoDe(owner)])
		jugadoresDeLaEncuesta.addAll(equipo2.integrantes.filter[!esAmigoDe(owner)])

		return jugadoresDeLaEncuesta
	}
	
	def participaEquipo(Equipo equipo) {
		equipo1.tieneId(equipo.idEquipo) || equipo2.tieneId(equipo.idEquipo)
	}
	
	def participaEquipo(Long idEquipo) {
		equipo1.tieneId(idEquipo) || equipo2.tieneId(idEquipo)
	}
	
	def startTimer(){
		val ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor()

		// Desde el momento de creacion de un partido hay X dias para confirmarlo y asi evitar su autoeliminacion
		scheduler.schedule(eliminarPartido, DIAS_PARA_CONFIRMAR, TimeUnit.DAYS)

		//Para La presentacion reducimos el tiempo de espera
		//val horasParaEnviarEncuesta = Duration.between(LocalDateTime.now, fechaDeReserva).plusHours(HORAS_DE_ESPERA_PARA_LA_ENCUESTA).toHours
		val horasParaEnviarEncuesta = 1
		
		//DEBUG
		//scheduler.schedule(enviarEncuestas, 20, TimeUnit.SECONDS)
		
		scheduler.schedule(enviarEncuestas, horasParaEnviarEncuesta, TimeUnit.MINUTES)
		//scheduler.schedule(enviarEncuestas, horasParaEnviarEncuesta, TimeUnit.HOURS)
		
		scheduler.shutdown()
	}
	
	def todaviaNoSeJugo() {
		println(LocalDateTime.now.isBefore(fechaDeReserva))
		LocalDateTime.now.isBefore(fechaDeReserva)
	}

}

// Lambda para la eliminacion de partidos
class EliminarPartido implements Runnable {

	Partido partido
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	RepositorioNotificacion repoNotificaciones = RepositorioNotificacion.instance

	new(Partido partido_) {
		partido = partido_
	}

	override run() {

		// Volvemos a ir al back para traer el estado de confirmacion 2 dias despues
		partido = RepositorioPartido.instance.searchById(partido.idPartido)

		if (!partido.confirmado) {
			println("[INFO]: Se va ha realizar la baja logica del partido sin confirmar con ID: " + partido.idPartido)

			repoNotificaciones.eliminarNotificacioneDePartidoById(partido.idPartido)

			RepositorioPartido.instance.eliminarPartido(partido)

			partido.equipo1 = repoEquipo.searchByIdConIntegrantes(partido.equipo1.idEquipo)
			partido.equipo2 = repoEquipo.searchByIdConIntegrantes(partido.equipo2.idEquipo)

			partido.eliminarJugadoresReservados()
		}

	}
}

// Lambda para la emicion de encuestas
class EnviarEncuesta implements Runnable {

	Partido partido
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	RepositorioNotificacion repoNotificaciones = RepositorioNotificacion.instance

	new(Partido partido_) {
		partido = partido_
	}

	override run() {
		
		partido = RepositorioPartido.instance.searchById(partido.idPartido)
		partido.equipo1 = RepositorioEquipo.instance.searchByIdConIntegrantes(partido.equipo1.idEquipo)
		partido.equipo2 = RepositorioEquipo.instance.searchByIdConIntegrantes(partido.equipo2.idEquipo)

		var integrantesTemp = new ArrayList<Usuario>
		integrantesTemp.addAll(partido.equipo1.integrantes)

		partido.equipo1.integrantes = new HashSet

		integrantesTemp.forEach [
			val usuarioPosta = RepositorioUsuario.instance.searchByIdConAmigos(it.idUsuario)

			if (usuarioPosta.idUsuario !== partido.owner.idUsuario) {
				partido.equipo1.integrantes.add(usuarioPosta)
			}

		]

		integrantesTemp = new ArrayList<Usuario>
		integrantesTemp.addAll(partido.equipo2.integrantes)

		partido.equipo2.integrantes = new HashSet

		integrantesTemp.forEach [
			val usuarioPosta = RepositorioUsuario.instance.searchByIdConAmigos(it.idUsuario)
			if (usuarioPosta.idUsuario !== partido.owner.idUsuario) {
				partido.equipo2.integrantes.add(usuarioPosta)
			}
		]

		val owner = partido.equipo1.owner
		val jugadoresInvitados = partido.jugadoresDeLaEncuesta

		jugadoresInvitados.forEach [ jugador |
			val encuesta = new Encuesta()

			encuesta.partido = partido
			encuesta.usuarioEncuestado = owner
			encuesta.usuarioReferenciado = jugador

			if (partido.estado && encuesta.noFueEnviada && !encuesta.usuarioReferenciado.esUnJugadorReservado) {
				println("Se van a enviar las encuestas de un partido")
				encuesta.enviar()
				
				//TODO: Delegar en un metodo enviarNotificacionEncuesta
				val notificacion = new Notificacion => [
				titulo = 'Has recibido una encuesta!'
				descripcion = 'Para el partido del dia (TODO Dia)'
				usuarioReceptor = encuesta.usuarioEncuestado
		]
		
			RepositorioNotificacion.instance.enviarUnaNotificacion(notificacion)
			}
		]

	}
}
