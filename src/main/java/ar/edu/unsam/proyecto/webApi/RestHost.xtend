package ar.edu.unsam.proyecto.webApi

import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Notificacion
import ar.edu.unsam.proyecto.domain.Partido
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.exceptions.IncorrectCredentials
import ar.edu.unsam.proyecto.exceptions.ObjectDoesntExists
import ar.edu.unsam.proyecto.repos.RepositorioCancha
import ar.edu.unsam.proyecto.repos.RepositorioEmpresa
import ar.edu.unsam.proyecto.repos.RepositorioEquipo
import ar.edu.unsam.proyecto.repos.RepositorioNotificacion
import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.repos.RepositorioPromocion
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import java.time.LocalDateTime
import java.util.HashSet
import java.util.List
import java.util.Set
import javax.persistence.NoResultException
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RestHost {
	RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	RepositorioPartido repoPartido = RepositorioPartido.instance
	RepositorioCancha repoCancha = RepositorioCancha.instance
	RepositorioEmpresa repoEmpresa = RepositorioEmpresa.instance
	RepositorioPromocion repoPromociones = RepositorioPromocion.instance
	RepositorioNotificacion repoNotificacion = RepositorioNotificacion.instance

	def getPeticionDePrueba() {
		return '{ "message": "La API Rest esta funcionando!! :)" }'
	}

	def loguearUsuario(Usuario usuario) {
		try {
			val usuarioPosta = repoUsuario.getUsuarioConCredenciales(usuario.email, usuario.password)

			if (usuario.token !== null) {
				val deviceToken = usuario.token
				usuarioPosta.token = deviceToken
				repoUsuario.update(usuarioPosta)
			}
			return usuarioPosta

		} catch (NoResultException e) {
			throw new IncorrectCredentials("Credenciales Invalidas")
		}

	}

	def signUpUsuario(Usuario usuario) {

		if (!repoUsuario.existeUsuarioConMail(usuario.email)) {
			repoUsuario.create(usuario)
		} else {
			throw new IncorrectCredentials("Este mail ya pertenece a un usuario")
		}
	}

	def getPartidosDelUsuario(Long idUsuario) {
		val usuarioPosta = repoUsuario.searchById(idUsuario)
		repoNotificacion.getPartidosDelUsuario(usuarioPosta)
	}

	def getEquiposDelUsuario(Long idUsuario) {
		val usuarioPosta = repoUsuario.searchById(idUsuario)
		repoEquipo.getEquiposDelUsuario(usuarioPosta)
	}

	def getEquiposAdministradosPorElUsuario(Long idUsuario) {
		val usuarioPosta = repoUsuario.searchById(idUsuario)
		repoEquipo.getEquiposAdministradosPorElUsuario(usuarioPosta)
	}

	def crearNuevoEquipo(Equipo equipo) {
		equipo.validar()
		repoEquipo.create(equipo)
	}

	def destinatariosConocidosContiene(Set<Usuario> destinatarios, Usuario usuario) {
		destinatarios.exists[jugador|jugador.idUsuario == usuario.idUsuario]
	}

	def usuarioEstaSiendoNotificado(Set<Usuario> destinatarios, Usuario usuario) {
		destinatarios.exists[jugador|jugador.idUsuario == usuario.idUsuario]
	}

	// https://i.imgur.com/j6UGUXn.jpg
	def crearNuevoPartido(Partido partido) {

		repoPartido.asignarIdPartido(partido)

		partido.mapearEmpresa()
		partido.mapearCancha()

		val Set<Usuario> destinatariosConocidos = new HashSet
		val Set<Usuario> destinatariosDesconocidos = new HashSet

		partido.mapearJugadoresConocidos

		destinatariosConocidos.addAll(partido.jugadoresConocidos)

		partido.jugadoresDesconocidos.forEach [ jugador |
			if (!usuarioEstaSiendoNotificado(destinatariosConocidos, jugador) &&
				!usuarioEstaSiendoNotificado(destinatariosDesconocidos, jugador) &&
				!destinatariosConocidos.contains(jugador)) {

				destinatariosDesconocidos.add(jugador)
			}
		]

		println("Usuarios conocidos a invitar: " + destinatariosConocidos.map[nombre])
		println("Usuarios desconocidos a invitar: " + destinatariosDesconocidos.map[nombre])

		partido.validarCreacion()

		partido.enviarNotifiacionesAConocidos(destinatariosConocidos, partido.equipo1.owner)
		partido.enviarNotifiacionesADesconocidos(destinatariosDesconocidos)

		partido.prepararParaPersistir()
		partido.validarPersistir()

		repoEquipo.createIfNotExists(partido.equipo1)
		repoEquipo.createIfNotExists(partido.equipo2)

		repoPartido.create(partido)

		println("Se ha creado un partido con id: " + partido.idPartido)

		destinatariosConocidos.forEach [ destinatario |

			if (destinatario.idUsuario != partido.equipo1.owner.idUsuario) {
				val invitacion = new Notificacion()
				invitacion.partido = partido
				invitacion.usuario = partido.equipo1.owner
				invitacion.titulo = "¡ " + partido.equipo1.owner.nombre + " te invito a un partido!"
				invitacion.descripcion = invitacion.partido.empresa.direccion + " - " +
					invitacion.partido.fechaDeReserva + " (TODO: Formatear bien la fecha)"
				invitacion.usuarioReceptor = destinatario

				repoNotificacion.agregarNotificacionAUsuario(invitacion, destinatario)
			}
		]

		destinatariosDesconocidos.forEach [ destinatario |
			val invitacion = new Notificacion()
			invitacion.partido = partido
			invitacion.usuario = partido.equipo1.owner
			invitacion.titulo = "¡Has recibido una invitacion para un partido!"
			invitacion.descripcion = invitacion.partido.empresa.direccion + " - " + invitacion.partido.fechaDeReserva +
				" (TODO: Formatear bien la fecha)"
			invitacion.usuarioReceptor = destinatario

			repoNotificacion.agregarNotificacionAUsuario(invitacion, destinatario)
		]

	}

	def getCanchas() {
		repoCancha.coleccion
	}

	def getEmpresas() {
		repoEmpresa.coleccion
	}

	// ESTO PARECE QUE ESTA REPETIDO, PERO ES SOLO QUE ESTAN MAL LOS NOMBRES
	def getEmpresaById(Long idEmpresa) {
		repoEmpresa.getEmpresaById(idEmpresa)
	}

	def getCanchasDeLaEmpresaById(Long idEmpresa) {
		getEmpresaById(idEmpresa).canchas
	}

	// ////////////////////////////////
	def getPromocionByCodigo(String codigo) {

		val promocion = repoPromociones.searchByCodigo(codigo)
		promocion !== null ? return promocion : throw new ObjectDoesntExists('No existe ese codigo promocional')
	}

	def void validarFechaCancha(LocalDateTime fecha) {
		repoPartido.validarFechaCancha(fecha)
	}

	def getAmigosDelUsuario(Long idUsuario) {
		repoUsuario.getAmigosDelUsuario(idUsuario)
	}

	def getNotificacionesDelUsuario(Long idUsuario) {
		repoUsuario.notificacionesDelUsuario(idUsuario)
	}

	def confirmarPartidoDeId(Long idPartido) {
		val partidoPosta = repoPartido.searchById(idPartido)
		partidoPosta.confirmarPartido()
	}

	def updateUbicacion(Usuario usuario) {

		if (usuario.lat != 0.0 && usuario.lon != 0.0) {
			val usuarioPosta = repoUsuario.searchById(usuario.idUsuario)

			usuarioPosta.lat = usuario.lat
			usuarioPosta.lon = usuario.lon

			repoUsuario.update(usuarioPosta)
		}
	}

	def debugNotificacion(Long idUsuario) {

		val usuarioPosta = repoUsuario.searchById(idUsuario)
		val notificacion = new Notificacion
		notificacion.titulo = "[DEBUG]"
		notificacion.descripcion = "Esta notificacion es una prueba"
		notificacion.usuario = usuarioPosta

		repoNotificacion.enviarUnaNotificacion(notificacion)

	}

	def debugNotificacionMultiple(List<Long> ids) {

		val usuariosPosta = new HashSet()

		ids.forEach[id|usuariosPosta.add(repoUsuario.searchById(id))]

		val notificacion = new Notificacion
		notificacion.titulo = "[DEBUG]"
		notificacion.descripcion = "Esta notificacion es una prueba"

		repoNotificacion.enviarMultipleNotificacion(notificacion, usuariosPosta)

	}

	def getCandidatosDelUsuario(Long idUsuario) {
		repoUsuario.getCandidatosDelUsuario(repoUsuario.searchByIdConAmigos(idUsuario))
	}

	/* 
	 * def getNotificacionesCandidatosDelUsuario(Long idUsuario) {
	 * 	repoNotificacion.getNotificacionesCandidatosByIdUsuario(idUsuario)
	 * }
	 */
	def getInvitacionesDelUsuario(Long idUsuario) {
		repoNotificacion.getInvitacionesDelUsuario(idUsuario)
	}

	def aceptarInvitacion(Long idNotificacion) {

		val notificacionPosta = repoNotificacion.searchById(idNotificacion)

		notificacionPosta.partido.equipo1 = repoEquipo.searchByIdConIntegrantes(
			notificacionPosta.partido.equipo1.idEquipo)
		notificacionPosta.partido.equipo2 = repoEquipo.searchByIdConIntegrantes(
			notificacionPosta.partido.equipo2.idEquipo)

		notificacionPosta.usuarioReceptor = repoUsuario.searchByIdConAmigos(notificacionPosta.usuarioReceptor.idUsuario)

		notificacionPosta.agregarIntegranteAlPartido()

	// repoNotificacion.aceptarInvitacion(notificacionPosta)
	// TODO: Enviar notificacion con firebase
	}

	def aceptarCandidato(Notificacion notificacionPosta) {

		notificacionPosta.partido.equipo1 = repoEquipo.searchByIdConIntegrantes(
			notificacionPosta.partido.equipo1.idEquipo)
		notificacionPosta.partido.equipo2 = repoEquipo.searchByIdConIntegrantes(
			notificacionPosta.partido.equipo2.idEquipo)

		notificacionPosta.agregarIntegranteAlPartido()

	// TODO: Quizas enviar notificaion con firebase
	}

	def agregarAmigoAUsuario(Long idUsuario, Long idAmigo) {

		val usuarioPosta = repoUsuario.searchByIdConAmigos(idUsuario)
		val amigoPosta = repoUsuario.searchByIdConAmigos(idAmigo)
		usuarioPosta.crearAmistad(amigoPosta)

		repoUsuario.update(usuarioPosta)
		repoUsuario.update(amigoPosta)

		val notiDeAmistad = new Notificacion
		notiDeAmistad.titulo = "¡" + usuarioPosta.nombre + " y tu ahora son amigos!"
		notiDeAmistad.usuario = amigoPosta
		repoNotificacion.enviarUnaNotificacion(notiDeAmistad)

	}

}
