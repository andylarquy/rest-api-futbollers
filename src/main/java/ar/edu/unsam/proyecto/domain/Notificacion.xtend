package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.repos.RepositorioNotificacion
import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.annotation.JsonView
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@JsonInclude(Include.NON_NULL) //En teoria si un campo es null no lo parsea 
class Notificacion {

	@JsonIgnore
	transient RepositorioNotificacion repoNotificacion = RepositorioNotificacion.instance

	@JsonView(ViewsNotificacion.NotificacionView)
	Long idNotificacion = repoNotificacion.getIdNotificacion

	@JsonView(ViewsNotificacion.NotificacionView)
	String titulo

	@JsonView(ViewsNotificacion.NotificacionView)
	String descripcion

	@JsonView(ViewsNotificacion.NotificacionView)
	Partido partido

	@JsonView(ViewsNotificacion.NotificacionView)
	Usuario usuarioReceptor

	@JsonIgnore
	transient Boolean aceptado = false

	@JsonIgnore
	transient RepositorioPartido repoPartido = RepositorioPartido.instance

	def esDelUsuario(Long idUsuario) {
		usuarioReceptor.idUsuario == idUsuario
	}

	def empresaTieneMail(String email) {
		partido.empresa.email.equals(email)
	}

	def partidoTieneId(Long idPartido) {
		partido.idPartido == idPartido
	}

	def agregarIntegranteAlPartido() {

		if (usuarioReceptor.esAmigoDe(partido.equipo1.owner)) {
			if (partido.faltanJugadores()) {
				aceptarInvitacionAmigo(usuarioReceptor)
				aceptado = true

				val notificacionTemporal = new Notificacion()
				notificacionTemporal.usuarioReceptor = partido.equipo1.owner
				notificacionTemporal.titulo = "¡" + usuarioReceptor.nombre + " acepto tu invitacion a un partido!"
				
				if(!partido.faltanJugadores){
					notificacionTemporal.descripcion = "¡El partido ya esta listo para la confirmacion!"
				}
				
				repoNotificacion.enviarUnaNotificacion(notificacionTemporal)
			
			} else {
				throw new Exception('No hay hueco en el partido para este jugador')
			}

		} else if (partido.faltanJugadores()) {
			
			aceptarInvitacionDesconocido(usuarioReceptor)
			aceptado = true

			val notificacionTemporal = new Notificacion()
			notificacionTemporal.usuarioReceptor = partido.equipo1.owner
			notificacionTemporal.titulo = "¡" + usuarioReceptor.nombre + " acepto tu invitacion a un partido!"
			if(!partido.faltanJugadores){
					notificacionTemporal.descripcion = "¡El partido ya esta listo para la confirmacion!"
				}
			repoNotificacion.enviarUnaNotificacion(notificacionTemporal)
		} else {
			throw new Exception('No hay hueco en el partido para este jugador')
		}

		aceptado = true
		repoPartido.update(partido)

	}

	def receptorFueAdmitido() {
		partido.participaUsuario(usuarioReceptor)
	}

	def esOwnerDelPartido(Usuario usuario) {
		partido.equipo1.esOwner(usuario)
	}

	def receptorEs(Usuario usuario) {
		usuarioReceptor.idUsuario == usuario.idUsuario
	}

	def aceptarInvitacionAmigo(Usuario usuario) {
		partido.cantidadDeConfirmaciones = partido.cantidadDeConfirmaciones + 1
	}

	def aceptarInvitacionDesconocido(Usuario usuario) {
		partido.agregarPuesto(usuarioReceptor)
		partido.cantidadDeConfirmaciones = partido.cantidadDeConfirmaciones + 1
	}

	def fueAceptada() {
		return aceptado
	}

	def receptorTieneId(Long idUsuario) {
		usuarioReceptor.idUsuario == idUsuario
	}

	def partidoEs(Partido partidoBuscado) {
		partido.idPartido == partidoBuscado.idPartido
	}

}
