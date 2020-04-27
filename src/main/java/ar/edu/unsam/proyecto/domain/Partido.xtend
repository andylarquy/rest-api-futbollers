package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartidoEmpresa
import com.fasterxml.jackson.annotation.JsonView
import java.time.LocalDateTime
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Partido {
	
	@JsonView(ViewsPartidoEmpresa.DefaultView) String id
	
	@JsonView(ViewsPartidoEmpresa.DetallesView) Usuario owner
	
	@JsonView(ViewsPartidoEmpresa.DefaultView) Equipo equipo1
	@JsonView(ViewsPartidoEmpresa.DefaultView) Equipo equipo2
	
	@JsonView(ViewsPartidoEmpresa.DefaultView) Empresa empresa
	@JsonView(ViewsPartidoEmpresa.DetallesView) Cancha canchaReservada
	@JsonView(ViewsPartidoEmpresa.DetallesView) LocalDateTime fechaDeReserva
	
	
	
	def validar(){
		true
	}

	
	
	//TODO: Separar en equipo y equipo completo
	def participaUsuario(Usuario usuario) {
		usuario == owner || equipo1.contieneA(usuario) || equipo2.contieneA(usuario)
	}
	
}