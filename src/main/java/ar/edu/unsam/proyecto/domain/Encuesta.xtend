package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.repos.RepositorioEncuesta
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.OneToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEncuesta
import com.fasterxml.jackson.annotation.JsonView

@Accessors
@Entity
@JsonInclude(Include.NON_NULL)
class Encuesta {
	
	@JsonView(ViewsEncuesta.DefaultView)
	@Id @GeneratedValue
	Long idEncuesta
	
	//TODO: Comprarse un diccionario
	@OneToOne
	@JsonView(ViewsEncuesta.DefaultView)
	Usuario usuarioEncuestado
	
	@OneToOne
	@JsonView(ViewsEncuesta.DefaultView)
	Usuario usuarioReferenciado
	
	@ManyToOne
	@JsonView(ViewsEncuesta.DefaultView)
	Partido partido
	
	@Column
	@JsonView(ViewsEncuesta.DefaultView)
	Boolean respuesta1
	
	@Column
	@JsonView(ViewsEncuesta.DefaultView)
	Boolean respuesta2
	
	@Column
	@JsonView(ViewsEncuesta.DefaultView)
	Boolean respuesta3
	
	@Transient
	transient RepositorioEncuesta repoEncuesta = RepositorioEncuesta.instance
	
	def enviar() {
		repoEncuesta.agregarEncuesta(this)
	}
	
}