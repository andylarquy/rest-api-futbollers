package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonView
import java.time.LocalDateTime
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Partido {
	
	@JsonView(ViewsPartido.DefaultView) 
	String id
	
	@JsonView(ViewsPartido.DefaultView) 
	Usuario owner
	
	@JsonView(ViewsPartido.ListView) 
	Equipo equipo1
	
	@JsonView(ViewsPartido.ListView) 
	Equipo equipo2
	
	@JsonView(ViewsPartido.DefaultView) 
	Empresa empresa
	
	@JsonView(ViewsPartido.DetallesView) 
	Cancha canchaReservada
	
	@JsonView(ViewsPartido.DetallesView) 
	LocalDateTime fechaDeReserva
	
	
	
	def validar(){
		true
	}

	
	
	//TODO: Separar en equipo y equipo completo
	def participaUsuario(Usuario usuario) {
		usuario == owner || equipo1.contieneA(usuario) || equipo2.contieneA(usuario)
	}
	
}