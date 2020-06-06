package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.repos.RepositorioEquipo
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.annotation.JsonView
import java.util.HashSet
import java.util.Set
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToMany
import javax.persistence.ManyToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
@JsonInclude(Include.NON_NULL)//En teoria si un campo es null no lo parsea 
class Equipo {
	
	@JsonView(ViewsEquipo.ListView, ViewsNotificacion.NotificacionView, ViewsPartido.DefaultView)
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
	
	@Transient
	transient RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	
	@Transient
	transient RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	
	
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
	
	def mapearJugadoresConocidos() {
		
		if(esEquipoConocido){

			val integrantesConocidos = new HashSet()
			integrantesConocidos.addAll(integrantes.filter[esIntegranteConocido])
			integrantes.removeAll(integrantesConocidos)
			integrantesConocidos.forEach[usuario | integrantes.add(repoUsuario.searchById(usuario.idUsuario))]
		}
		
		owner = repoUsuario.searchById(owner.idUsuario)
	}
	
	def esEquipoConocido(){
		this.idEquipo != -1
	}
	
	def asignarNombreTemporal(){
		if(idEquipo < 0){
			nombre = "Equipo Temporal Nro. "+repoEquipo.coleccion.size
		}
	}
	
	def getAsignarIdEquipoTemporal() {
		if(idEquipo < 0){
			//Es null a proposito
			idEquipo = null
		}
	}
	
	
}