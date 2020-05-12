package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonView
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Equipo {
	
	@JsonView(ViewsEquipo.ListView) 
	String id
	
	@JsonView(ViewsEquipo.ListView, ViewsPartido.ListView) 
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
		//TODO: Ver que hacer si se intenta remover un usuario que es owner
		integrantes.remove(integrante)
	}
	
	def validar(){
		//TODO: Validar
		true
	}
	
	def participaUsuario(Usuario usuario){
		esOwner(usuario) || integrantes.contains(usuario)
	}
	
	def esOwner(Usuario usuario){
		usuario == owner
	}
	
	def idDeIntegrantes() {
		integrantes.map[id].toList
	}
	
}