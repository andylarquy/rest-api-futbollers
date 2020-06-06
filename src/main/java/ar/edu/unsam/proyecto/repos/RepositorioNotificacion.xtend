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
	
	def notificacionesDelUsuario(Long idUsuario){
		coleccion.filter[notificacion| notificacion.esDelUsuario(idUsuario)]
	}
	
	def agregarNotificacion(Notificacion notificacion) {
		if(coleccion.exists[invitacion | 
			invitacion.empresaTieneMail(notificacion.partido.empresa.email) &&
			invitacion.esDelUsuario(notificacion.usuario.idUsuario)
	
		]){
			
		}else{
			coleccion.add(notificacion)
		}
	}
	
}