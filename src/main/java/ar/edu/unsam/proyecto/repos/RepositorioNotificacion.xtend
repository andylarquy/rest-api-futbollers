package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Notificacion
import java.util.Set

class RepositorioNotificacion extends Repositorio<Notificacion> {
	
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
	
	override entityType() {
		Notificacion
	}
	
	
}