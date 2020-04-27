package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartidoEmpresa
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonView
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Equipo {
	
	@JsonView(ViewsPartidoEmpresa.DefaultView) String id
	@JsonView(ViewsPartidoEmpresa) String nombre
	
	@JsonView(ViewsPartidoEmpresa) Usuario owner

	 @JsonView(ViewsPartidoEmpresa) List<Usuario> integrantes //Capaz conviene que sea un Set para no cagarla
	
	def agregarIntegrante(Usuario integrante){
		integrantes.add(integrante)
	}
	
	def quitarIntegrante(Usuario integrante){
		integrantes.remove(integrante)
	}
	
	//TODO: Separar en equipo y equipo completo
	def contieneA(Usuario usuario) {
		owner == usuario || integrantes.contains(usuario)
	}
	
}