package ar.edu.unsam.proyecto.domain

import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity@JsonInclude(Include.NON_NULL)//En teoria si un campo es null no lo parsea 
class Promocion {

	@Id @GeneratedValue
	Long idPromocion

	@Column()
	String codigo
	
	@Column()
	String descripcion
	
	
	@Column()
	int porcentajeDescuento

	def validar() {
		true
	}
}
