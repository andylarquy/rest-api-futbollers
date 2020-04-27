package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEmpresa
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonView
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
class Empresa {
	
	
	@JsonView(ViewsEmpresa.DefaultView, ViewsEquipo.ListView, ViewsPartido.ListView) 
	String id
	
	@JsonView(ViewsEmpresa.DefaultView, ViewsEquipo.ListView, ViewsPartido.ListView) 
	String nombre

	//Revisar si tienen q estar
	@JsonView(ViewsEmpresa.DetallesView) 
	Double lat
	
	@JsonView(ViewsEmpresa.DetallesView) 
	Double lon
	
	@JsonView(ViewsEmpresa.DetallesView)
	String nombreDuenio
	 
	@JsonView(ViewsEmpresa.DetallesView) 
	String email
	
	@JsonView(ViewsEmpresa.DetallesView) 
	Point lugar
	
	@JsonView(ViewsEquipo.ListView, ViewsEmpresa.DefaultView, ViewsPartido.ListView) 
	String direccion
	
	@JsonView(ViewsEmpresa.DefaultView, ViewsEquipo.ListView, ViewsPartido.ListView) 
	String foto
	
	
	@JsonView(ViewsEmpresa.DetallesView) 
	List<Cancha> canchas
	
	def agregarCancha(Cancha cancha){
		canchas.add(cancha)
	}
	
	def quitarCancha(Cancha cancha){
		canchas.remove(cancha)
	}
	
	
}