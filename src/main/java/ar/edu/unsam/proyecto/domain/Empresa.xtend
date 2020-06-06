package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEmpresa
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.annotation.JsonView
import java.util.Set
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.OneToMany
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
@Entity
@JsonInclude(Include.NON_NULL)//En teoria si un campo es null no lo parsea 
class Empresa {
	
	
	@JsonView(ViewsEmpresa.DefaultView, ViewsEquipo.ListView, ViewsPartido.ListView, ViewsNotificacion.NotificacionView)
	@Id @GeneratedValue
	Long idEmpresa
	
	@Column()
	@JsonView(ViewsEmpresa.DefaultView, ViewsEquipo.ListView, ViewsPartido.ListView) 
	String nombre

	//Revisar si tienen q estar
	@Column()
	@JsonView(ViewsEmpresa.DetallesView) 
	Double lat
	
	@Column()
	@JsonView(ViewsEmpresa.DetallesView) 
	Double lon
	
	@Column()
	@JsonView(ViewsEmpresa.DetallesView)
	String nombreDuenio
	
	@Column() 
	@JsonView(ViewsEmpresa.ListView, ViewsEmpresa.DetallesView) 
	String email
	
//	@Column()
	@JsonView(ViewsEmpresa.DetallesView) 
	transient Point lugar
	
	@Column()
	@JsonView(ViewsEmpresa.ListView, ViewsEquipo.ListView, ViewsEmpresa.DefaultView, ViewsPartido.ListView, ViewsNotificacion.NotificacionView) 
	String direccion
	
	@Column()
	@JsonView(ViewsEmpresa.ListView, ViewsEmpresa.DefaultView, ViewsEquipo.ListView, ViewsPartido.ListView, ViewsNotificacion.NotificacionView) 
	String foto
	
	@OneToMany
	@JsonView(ViewsEmpresa.DetallesView) 
	Set<Cancha> canchas
	
	def agregarCancha(Cancha cancha){
		canchas.add(cancha)
	}
	
	def quitarCancha(Cancha cancha){
		canchas.remove(cancha)
	}
	
	//TODO: Esto
	def validar(){
		true
	}
	
	def tieneId(Long idBuscado) {
		idEmpresa.equals(idBuscado)
	}
	
	
}