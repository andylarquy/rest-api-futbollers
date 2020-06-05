package ar.edu.unsam.proyecto.domain

import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Column
import javax.persistence.ManyToOne

@Entity
@Accessors
class Notificacion{
	
	@Id @GeneratedValue
	Long idNotificacion
	
	@Column()
	String descripcion
	
	transient Partido partido
	
	transient Equipo equipo
	
	transient Usuario usuario
}
