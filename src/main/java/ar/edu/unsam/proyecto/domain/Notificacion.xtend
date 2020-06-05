package ar.edu.unsam.proyecto.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Notificacion{
	Long idNotificacion
	String descripcion
}

@Accessors
class NotificacionInvitacion extends Notificacion{
	Partido partido
}

@Accessors
class NotificacionCandidato extends Notificacion {
	Equipo equipo
	Usuario usuario
	
}