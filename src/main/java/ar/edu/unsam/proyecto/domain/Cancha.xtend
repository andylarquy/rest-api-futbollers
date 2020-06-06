package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsCancha
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEmpresa
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.annotation.JsonView
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
@JsonInclude(Include.NON_NULL)//En teoria si un campo es null no lo parsea 
class Cancha {
	
	@Id @GeneratedValue
	@JsonView(ViewsEmpresa.SetupView, ViewsCancha.DefaultView, ViewsNotificacion.NotificacionView)
	Long idCancha
	
	@Column()
	@JsonView(ViewsCancha.DefaultView)
	int cantidadJugadores
	
	@Column()
	@JsonView(ViewsCancha.DefaultView)
	String foto
	
	@Column()
	@JsonView(ViewsCancha.DefaultView)
	String superficie
	
	@Column()
	@JsonView(ViewsCancha.DefaultView)
	Double precio

	def validar(){
		if (idCancha === null){
			throw new Exception('La cancha debe tener un ID')
		} 
		
		if (foto === null){
			throw new Exception('La cancha debe tener una foto')
		}
		
		if (superficie === null){
			throw new Exception('La cancha debe tener un tipo de superficie')
		}  
		
		if (cantidadJugadores < 1){
			throw new Exception('La cantidad maxima de jugadores debe ser mayor a 1')
		}  
		
		if (cantidadJugadores % 2 != 0){
			throw new Exception('La cantidad maxima de jugadores debe ser par')
		}
		
	}
	
}