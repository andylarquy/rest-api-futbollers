package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Notificacion
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepositorioNotificacion {

	public static RepositorioNotificacion repoNotificacion

	static def RepositorioNotificacion getInstance() {
		if (repoNotificacion === null) {
			repoNotificacion = new RepositorioNotificacion()
		}
		repoNotificacion
	}

	def reset() {
		repoNotificacion = null
	}

	Set<Notificacion> coleccion = new HashSet()
	
	Long idAutoincremental = Long.valueOf(1)
	
	def asignarIdNotificacion(Notificacion noti) {
		noti.idNotificacion = idAutoincremental
		idAutoincremental++
	}

	def notificacionesDelUsuario(Long idUsuario) {
		coleccion.filter[notificacion|notificacion.esDelUsuario(idUsuario)].toSet
	}

	def agregarNotificacion(Notificacion notificacion) {
		if (usuarioYaFueInvitadoAlPartido(notificacion) || usuarioAInvitarEsOwner(notificacion)) {
		
		} else {
			asignarIdNotificacion(notificacion)
			coleccion.add(notificacion)
		}
	}
	
	def usuarioAInvitarEsOwner(Notificacion notificacion) {
		notificacion.partido.equipo1.owner.idUsuario === notificacion.usuario.idUsuario
	}

	def usuarioYaFueInvitadoAlPartido(Notificacion notificacion) {
		coleccion.exists [ invitacion |
			invitacion.empresaTieneMail(notificacion.partido.empresa.email) &&
				invitacion.esDelUsuario(notificacion.usuario.idUsuario)
		]
	}
}
