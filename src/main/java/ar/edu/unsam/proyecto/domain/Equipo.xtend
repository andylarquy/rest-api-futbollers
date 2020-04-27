package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonView
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Equipo {
	
	@JsonView(ViewsPartido.DefaultView) 
	String id
	
	@JsonView(ViewsEquipo.ListView) 
	String nombre
	
	@JsonView(ViewsEquipo.ListView) 
	String foto
	
	@JsonView(ViewsEquipo.ListView) 
	Usuario owner

	@JsonView(ViewsEquipo.ListView) 
	List<Usuario> integrantes //Capaz conviene que sea un Set para no cagarla
	
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
	
	def validar(){
		true
	}
	
	def participaUsuario(Usuario usuario){
		println(usuario.id)
		println(owner.id)
		println(integrantes.map[id])
		esOwner(usuario) || integrantes.contains(usuario)
	}
	
	def esOwner(Usuario usuario){
		usuario == owner
	}
	
}