package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEmpresa
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartidoEmpresa
import com.fasterxml.jackson.annotation.JsonView
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
class Empresa {
	
	
	@JsonView(ViewsPartidoEmpresa.DefaultView) String id
	@JsonView(ViewsPartidoEmpresa.DefaultView) String nombre
	
	//Revisar si tienen q estar
	@JsonView(ViewsPartidoEmpresa.DetallesView) Double lat
	@JsonView(ViewsPartidoEmpresa.DetallesView) Double lon
	@JsonView(ViewsPartidoEmpresa.DetallesView) String nombreDuenio
	@JsonView(ViewsPartidoEmpresa.DetallesView) String email
	@JsonView(ViewsPartidoEmpresa.DetallesView) Point lugar
	@JsonView(ViewsPartidoEmpresa.DefaultView) String direccion
	@JsonView(ViewsPartidoEmpresa.DefaultView) String foto
	
	@JsonView(ViewsPartidoEmpresa.DetallesView) List<Cancha> canchas
	
	def agregarCancha(Cancha cancha){
		canchas.add(cancha)
	}
	
	def quitarCancha(Cancha cancha){
		canchas.remove(cancha)
	}
	
	
}