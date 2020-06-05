package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonView
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToMany
import javax.persistence.ManyToOne
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Set

@Accessors
@Entity
class Equipo {
	
	@JsonView(ViewsEquipo.ListView)
	@Id @GeneratedValue  
	Long idEquipo
	
	@Column()
	@JsonView(ViewsEquipo.ListView, ViewsPartido.ListView) 
	String nombre
	
	@Column()
	@JsonView(ViewsEquipo.ListView) 
	String foto
	
	@ManyToOne
	@JsonView(ViewsEquipo.ListView) 
	Usuario owner
	
	@ManyToMany
	@JsonView(ViewsEquipo.ListView) 
	Set<Usuario> integrantes //Capaz conviene que sea un Set para no cagarla
	
	def agregarIntegrante(Usuario integrante){
		integrantes.add(integrante)
	}
	
	def quitarIntegrante(Usuario integrante){
		//TODO: Ver que hacer si se intenta remover un usuario que es owner
		integrantes.remove(integrante)
	}
	
	def validar(){
		
		if (nombre === null){
			throw new Exception('El equipo debe tener un nombre')
		}
		
		if (foto === null){
			throw new Exception('El equipo debe tener una foto')
		}
		
		if (owner  === null){
			throw new Exception('El equipo debe tener un dueño')
		}
		
		owner.validar
		
		if (integrantes === null){
			throw new Exception('El equipo debe tener una lista de integrantes')
		}
		
	}
	
	def participaUsuario(Usuario usuario){
		esOwner(usuario) || integrantes.exists[integrante | integrante.idUsuario.equals(usuario.idUsuario)]
	}
	
	def esOwner(Usuario usuario){
		usuario.idUsuario == owner.idUsuario
	}
	
	def idDeIntegrantes() {
		integrantes.map[idEquipo].toList
	}
	
	def getUsuariosTemporales() {
		integrantes.filter[it.esIntegranteDesconocido]
	}
	
}