package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsUsuario
import com.fasterxml.jackson.annotation.JsonView
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Usuario {

	@JsonView(ViewsUsuario.IdView, ViewsPartido.DefaultView, ViewsEquipo.ListView) 
	String id
	
	@JsonView(ViewsUsuario.DefaultView) 
	String nombre = ""
	
	@JsonView(ViewsUsuario.CredencialesView) 
	String password = ""
	
	@JsonView(ViewsUsuario.PerfilView)
	String foto
	
	@JsonView(ViewsUsuario.PerfilView)
	 String sexo
	 
	@JsonView(ViewsUsuario.PerfilView) 
	String posicion
	
	@JsonView(ViewsUsuario.DefaultView) 
	String email
	
	@JsonView(ViewsUsuario.UbicacionView)
	 Double lat
	 
	@JsonView(ViewsUsuario.UbicacionView) 
	Double lon

	def validar() {
		true
	}
	
	def tieneCredenciales(String email_, String password_){
		email.equals(email_) && password.equals(password_)
	}
	
	def tieneEsteMail(String email) {
		
		this.email.equals(email)
		
	}

}
