package ar.edu.unsam.proyecto.webApi

import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Notificacion
import ar.edu.unsam.proyecto.domain.Partido
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.exceptions.IncorrectCredentials
import ar.edu.unsam.proyecto.exceptions.InsufficientCandidates
import ar.edu.unsam.proyecto.exceptions.ObjectAlreadyExists
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
import ar.edu.unsam.proyecto.repos.RepositorioEncuesta
import ar.edu.unsam.proyecto.domain.Encuesta
import java.util.ArrayList

@Accessors
class RestHost {
	RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	RepositorioPartido repoPartido = RepositorioPartido.instance
	RepositorioCancha repoCancha = RepositorioCancha.instance
	RepositorioEmpresa repoEmpresa = RepositorioEmpresa.instance
	RepositorioPromocion repoPromociones = RepositorioPromocion.instance
	RepositorioNotificacion repoNotificacion = RepositorioNotificacion.instance
	RepositorioEncuesta repoEncuesta = RepositorioEncuesta.instance

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
		equipo.validarCreacion()
		// TODO: Mover validacion al metodo de arriba
		if (repoEquipo.coleccion.exists[it.tieneNombre(equipo.nombre) && it.esOwner(equipo.owner)]) {
			throw new ObjectAlreadyExists('Ya tienes un equipo con ese nombre')
		}

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
		partido.validarDiasDeConfirmacionFechaDeReserva

		val Set<Usuario> destinatariosConocidos = new HashSet
		val Set<Usuario> destinatariosDesconocidos = new HashSet

		partido.mapearJugadoresConocidos

		destinatariosConocidos.addAll(partido.jugadoresConocidos)

		println(partido.jugadoresDesconocidos.map[nombre])

		partido.jugadoresDesconocidos.forEach [ jugador |

			if (!usuarioEstaSiendoNotificado(destinatariosConocidos, jugador) &&
				!usuarioEstaSiendoNotificado(destinatariosDesconocidos, jugador) && !destinatariosConocidos.exists [
					it.idUsuario == jugador.idUsuario
				] && !partido.equipo1.owner.esAmigoDe(jugador)) {

				destinatariosDesconocidos.add(jugador)
			}
		]

		println("Usuarios conocidos a invitar: " + destinatariosConocidos.map[nombre])
		println("Usuarios desconocidos a invitar: " + destinatariosDesconocidos.map[nombre])

		if (destinatariosConocidos.size + destinatariosDesconocidos.size < partido.canchaReservada.cantidadJugadores) {
			throw new InsufficientCandidates(
				'No se han encontrado suficientes jugadores con esos parametros de busqueda')
		}

		partido.validarCreacion()

		// Antes de enviar las notificaciones removemos al owner para que no se notifique a si mismo
		destinatariosConocidos.removeIf[jugador|jugador.idUsuario == partido.equipo1.owner.idUsuario]

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
				invitacion.usuarioReceptor = partido.equipo1.owner
				invitacion.titulo = "¡ " + partido.equipo1.owner.nombre + " te invito a un partido!"
				invitacion.descripcion = invitacion.partido.empresa.direccion + " - " +
					invitacion.partido.fechaDeReserva + " (TODO: Formatear bien la fecha)"
				invitacion.usuarioReceptor = destinatario

				// CAMBIADO A agregarNotificacion
				repoNotificacion.agregarNotificacion(invitacion)
			}
		]

		destinatariosDesconocidos.forEach [ destinatario |
			val invitacion = new Notificacion()
			invitacion.partido = partido
			invitacion.usuarioReceptor = partido.equipo1.owner
			invitacion.titulo = "¡Has recibido una invitacion para un partido!"
			invitacion.descripcion = invitacion.partido.empresa.direccion + " - " + invitacion.partido.fechaDeReserva +
				" (TODO: Formatear bien la fecha)"
			invitacion.usuarioReceptor = destinatario

			// CAMBIADO A agregarNotificacion
			repoNotificacion.agregarNotificacion(invitacion)
		]

		// Se setean los tiempos de espera para la confirmacion del partido y el envio de encuestas
		partido.startTimer

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

	def void validarFechaCancha(LocalDateTime fecha, Long idCancha) {
		val canchaPosta = repoCancha.searchById(idCancha)
		repoPartido.validarFechaCancha(fecha, canchaPosta)
	}

	def getAmigosDelUsuario(Long idUsuario) {
		repoUsuario.getAmigosDelUsuario(idUsuario)
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
		notificacion.usuarioReceptor = usuarioPosta

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

	def getInvitacionesDelUsuario(Long idUsuario) {
		repoNotificacion.getInvitacionesDelUsuario(idUsuario)
	}

	def aceptarInvitacion(Long idNotificacion) {

		val notificacionPosta = repoNotificacion.searchById(idNotificacion)

		if (!notificacionPosta.aceptado) {

			notificacionPosta.partido.equipo1 = repoEquipo.searchByIdConIntegrantes(
				notificacionPosta.partido.equipo1.idEquipo)
			notificacionPosta.partido.equipo2 = repoEquipo.searchByIdConIntegrantes(
				notificacionPosta.partido.equipo2.idEquipo)

			notificacionPosta.usuarioReceptor = repoUsuario.searchByIdConAmigos(
				notificacionPosta.usuarioReceptor.idUsuario)

			notificacionPosta.agregarIntegranteAlPartido()
		} else {
			throw new Exception('Esta invitacion ya ha sido aceptada')
		}
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
		notiDeAmistad.usuarioReceptor = amigoPosta
		repoNotificacion.enviarUnaNotificacion(notiDeAmistad)
	}

	def rechazarInvitacion(Long idNotificacion) {
		val notificacionPosta = repoNotificacion.searchById(idNotificacion)
		repoNotificacion.eliminarNoitificacion(notificacionPosta)
	}

	def debug() {
		repoNotificacion.coleccion
	}

	// Programo con los codos
	def editarEquipo(Equipo equipo) {
		try {
			val equipoPosta = repoEquipo.searchById(equipo.idEquipo)
			val integrantesPosta = equipo.integrantes.map[integ|repoUsuario.searchById(integ.idUsuario)].toSet

			equipoPosta.nombre = equipo.nombre
			equipoPosta.integrantes = integrantesPosta
			equipoPosta.idEquipo = equipo.idEquipo
			equipoPosta.foto = equipo.foto

			repoEquipo.update(equipoPosta)
		} catch (NoResultException e) {
			throw new ObjectDoesntExists('Se está intentando editar un equipo con un ID que no existe en la base')
		}

	}

	def getEquipoById(Long idEquipo) {
		val equipo = repoEquipo.searchByIdConIntegrantes(idEquipo)
		equipo.integrantes.forEach[integrante|repoUsuario.searchById(integrante.idUsuario)]
		return equipo
	}

	def bajaLogicaEquipo(Long idEquipo) {
		val equipoPosta = repoEquipo.searchById(idEquipo)
		equipoPosta.estado = false
		repoEquipo.update(equipoPosta)
	}

	def encuestasDelUsuario(Long idUsuario) {
		val encuestas = new ArrayList
		encuestas.addAll(repoEncuesta.getEncuestasDelUsuario(idUsuario))
		encuestas.filter[!it.fueRespondida].toList
	}

	def updateEncuesta(Encuesta encuesta) {
		val encuestaPosta = repoEncuesta.searchById(encuesta.idEncuesta)

		encuestaPosta.respuesta1 = encuesta.respuesta1
		encuestaPosta.respuesta2 = encuesta.respuesta2
		encuestaPosta.respuesta3 = encuesta.respuesta3

		repoEncuesta.update(encuestaPosta)
	}

	def getUsuarioById(Long idUsuario) {
		repoUsuario.searchById(idUsuario)
	}

	def usuarioAbandonaEquipo(Long idEquipo, Long idUsuario) {
		//Esto esta todo mal programado, la interfaz de los repos funcionan diferente
		val equipoPosta = repoEquipo.searchByIdConIntegrantes(idEquipo)

		var Usuario usuarioPosta
		
		try{
			usuarioPosta = repoUsuario.searchById(idUsuario)
		}catch(NoResultException e){
			throw new ObjectDoesntExists('No existe un usuario con ese ID')
		}

		if (equipoPosta.participaUsuarioById(usuarioPosta.idUsuario)) {
			equipoPosta.quitarIntegranteById(usuarioPosta.idUsuario)
			repoEquipo.update(equipoPosta)
		} else {
			throw new ObjectDoesntExists('El usuario no forma parte de este equipo')
		}

	}

}
